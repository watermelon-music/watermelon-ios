import 'dart:async';

import 'package:flutter/foundation.dart';

import '../config/app_constants.dart';
import '../domain/autoplay/autoplay_engine.dart';
import '../domain/models/song.dart';
import '../domain/repositories/download_repository.dart';
import '../domain/repositories/streaming_repository.dart';
import '../domain/repositories/url_extractor_repository.dart';

enum RepeatMode { none, all, one }

/// Immutable playback state surfaced to the UI.
@immutable
class PlaybackState {
  final Song? currentSong;
  final List<Song> queue;
  final int currentIndex;
  final bool isPlaying;
  final bool isBuffering;
  final int positionMs;
  final int durationMs;
  final RepeatMode repeatMode;
  final bool isShuffled;
  final int? sleepRemainingSec;

  const PlaybackState({
    this.currentSong,
    this.queue = const [],
    this.currentIndex = -1,
    this.isPlaying = false,
    this.isBuffering = false,
    this.positionMs = 0,
    this.durationMs = 0,
    this.repeatMode = RepeatMode.none,
    this.isShuffled = false,
    this.sleepRemainingSec,
  });

  bool get hasNext => currentIndex >= 0 && currentIndex < queue.length - 1;
  bool get hasPrevious => currentIndex > 0;

  PlaybackState copyWith({
    Song? currentSong,
    List<Song>? queue,
    int? currentIndex,
    bool? isPlaying,
    bool? isBuffering,
    int? positionMs,
    int? durationMs,
    RepeatMode? repeatMode,
    bool? isShuffled,
    int? sleepRemainingSec,
    bool clearSleep = false,
  }) {
    return PlaybackState(
      currentSong: currentSong ?? this.currentSong,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      positionMs: positionMs ?? this.positionMs,
      durationMs: durationMs ?? this.durationMs,
      repeatMode: repeatMode ?? this.repeatMode,
      isShuffled: isShuffled ?? this.isShuffled,
      sleepRemainingSec:
          clearSleep ? null : (sleepRemainingSec ?? this.sleepRemainingSec),
    );
  }
}

/// Orchestrates playback: queue navigation, repeat/shuffle, source resolution
/// (download → audioUrl → yt-dlp extraction), autoplay refill, and analytics.
/// Ported from Kotlin `PlayerViewModel` (see LOGIC_IMPLEMENTATION.md §7).
class PlaybackController extends ChangeNotifier implements StreamingCallback {
  final StreamingRepository _streaming;
  final UrlExtractorRepository _extractor;
  final DownloadRepository _downloads;
  final AutoplayEngine _autoplay;

  PlaybackState _state = const PlaybackState();
  PlaybackState get state => _state;

  List<Song> _originalQueue = const [];
  int _consecutiveErrors = 0;
  Timer? _sleepTimer;
  Timer? _positionTimer;

  PlaybackController(
    this._streaming,
    this._extractor,
    this._downloads,
    this._autoplay,
  ) {
    _streaming.addListener(this);
    // Poll the engine's position while playing so the scrubber/mini-player
    // advance (just_audio's position isn't surfaced through the callback
    // contract). Inert when paused; cancelled on dispose.
    _positionTimer =
        Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!_state.isPlaying) return;
      final pos = _streaming.currentPosition();
      if (pos != _state.positionMs) {
        _set(_state.copyWith(positionMs: pos));
      }
    });
  }

  void _set(PlaybackState s) {
    _state = s;
    notifyListeners();
  }

  // ── Public controls ─────────────────────────────────────────────────────────

  Future<void> playQueue(List<Song> songs, {int startIndex = 0}) async {
    if (songs.isEmpty) return;
    _originalQueue = List.of(songs);
    _set(_state.copyWith(
      queue: List.of(songs),
      currentIndex: startIndex,
      isShuffled: false,
    ));
    await _playCurrent();
  }

  Future<void> togglePlayPause() async {
    if (_state.isPlaying) {
      _streaming.pause();
    } else {
      _streaming.resume();
    }
  }

  void seekTo(int positionMs) {
    _streaming.seekTo(positionMs);
    _set(_state.copyWith(positionMs: positionMs));
  }

  /// Output volume, 0.0–1.0. Volume isn't part of [PlaybackState] (the engine
  /// owns it); the desktop transport bar keeps the slider's value locally.
  void setVolume(double volume) =>
      _streaming.setVolume(volume.clamp(0.0, 1.0));

  /// User-initiated skip forward (records a skip of the current song).
  Future<void> next() async {
    final current = _state.currentSong;
    if (current != null) {
      await _autoplay.recordSkip(current, 'user_next');
    }
    await _advance(userInitiated: true);
  }

  Future<void> previous() async {
    if (_state.positionMs > 3000) {
      seekTo(0);
      return;
    }
    if (_state.hasPrevious) {
      _set(_state.copyWith(currentIndex: _state.currentIndex - 1));
      await _playCurrent();
    } else {
      seekTo(0);
    }
  }

  void cycleRepeat() {
    final next = switch (_state.repeatMode) {
      RepeatMode.none => RepeatMode.all,
      RepeatMode.all => RepeatMode.one,
      RepeatMode.one => RepeatMode.none,
    };
    _set(_state.copyWith(repeatMode: next));
  }

  void toggleShuffle() {
    if (_state.isShuffled) {
      // Restore original order, keeping the current song selected.
      final current = _state.currentSong;
      final restored = List.of(_originalQueue);
      final idx = current == null
          ? 0
          : restored.indexWhere((s) => s.id == current.id).clamp(0, restored.length - 1);
      _set(_state.copyWith(
          queue: restored, currentIndex: idx, isShuffled: false));
    } else {
      final current = _state.currentSong;
      final rest = List.of(_state.queue)..shuffle();
      if (current != null) {
        rest.removeWhere((s) => s.id == current.id);
        rest.insert(0, current);
      }
      _set(_state.copyWith(queue: rest, currentIndex: 0, isShuffled: true));
    }
  }

  void setSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    var remaining = minutes * 60;
    _set(_state.copyWith(sleepRemainingSec: remaining));
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      remaining -= 1;
      if (remaining <= 0) {
        t.cancel();
        _streaming.pause();
        _set(_state.copyWith(clearSleep: true));
      } else {
        _set(_state.copyWith(sleepRemainingSec: remaining));
      }
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _set(_state.copyWith(clearSleep: true));
  }

  // ── Internal ─────────────────────────────────────────────────────────────────

  Future<void> _advance({required bool userInitiated}) async {
    final from = _state.currentSong;

    if (_state.hasNext) {
      _set(_state.copyWith(currentIndex: _state.currentIndex + 1));
      await _recordTransition(from, _state.queue[_state.currentIndex]);
      await _playCurrent();
      return;
    }

    // End of queue.
    if (_state.repeatMode == RepeatMode.all && _state.queue.isNotEmpty) {
      _set(_state.copyWith(currentIndex: 0));
      await _recordTransition(from, _state.queue.first);
      await _playCurrent();
      return;
    }

    // Autoplay refill.
    final excludeIds = _state.queue.map((s) => s.id).toSet();
    final nextSong = from == null
        ? null
        : await _autoplay.findNextSong(from, excludeIds: excludeIds);
    if (nextSong != null) {
      final newQueue = List.of(_state.queue)..add(nextSong);
      _set(_state.copyWith(
          queue: newQueue, currentIndex: newQueue.length - 1));
      await _recordTransition(from, nextSong);
      await _playCurrent();
    } else {
      _streaming.stop();
      _set(_state.copyWith(isPlaying: false));
    }
  }

  Future<void> _recordTransition(Song? from, Song to) async {
    if (from != null && from.id != to.id) {
      await _autoplay.recordTransition(from.id, to.id);
    }
  }

  Future<void> _playCurrent() async {
    final song = _state.queue[_state.currentIndex];
    _set(_state.copyWith(
        currentSong: song, isBuffering: true, positionMs: 0, durationMs: 0));

    final url = await _resolveSource(song);
    if (url == null) {
      await _advance(userInitiated: false); // skip unresolvable track
      return;
    }
    _consecutiveErrors = 0;
    _streaming.play(
      url,
      title: song.title,
      artist: song.artistName,
      artworkUrl: song.coverUrl ?? '',
    );
    await _autoplay.recordPlayStart(song, 'queue');
  }

  /// download → song.audioUrl → yt-dlp extraction.
  Future<String?> _resolveSource(Song song) async {
    final path = await _downloads.getDownloadPath(song.id);
    if (path != null && path.isNotEmpty) return path;

    final url = song.audioUrl;
    if (url != null && url.isNotEmpty) return url;

    final extracted = await _extractor.extractAudioUrl(song.id);
    return extracted.valueOrNull;
  }

  // ── StreamingCallback ────────────────────────────────────────────────────────

  @override
  void onIsPlayingChanged(bool isPlaying) =>
      _set(_state.copyWith(isPlaying: isPlaying));

  @override
  void onPlaybackStateChanged(bool isBuffering) =>
      _set(_state.copyWith(isBuffering: isBuffering));

  @override
  void onDurationChanged(int durationMs) =>
      _set(_state.copyWith(durationMs: durationMs));

  @override
  void onPositionDiscontinuity() {}

  @override
  void onPlaybackCompleted() {
    if (_state.repeatMode == RepeatMode.one) {
      seekTo(0);
      _streaming.resume();
    } else {
      _advance(userInitiated: false);
    }
  }

  @override
  void onPlaybackError(String error) {
    _consecutiveErrors++;
    final song = _state.currentSong;
    if (_consecutiveErrors < AppConstants.maxConsecutivePlayErrors &&
        song != null) {
      _extractor.invalidateCache(song.id);
      _playCurrent();
    } else {
      _advance(userInitiated: false);
    }
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _positionTimer?.cancel();
    _streaming.removeListener(this);
    super.dispose();
  }
}
