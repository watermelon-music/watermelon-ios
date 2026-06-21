import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/track.dart';

/// Immutable snapshot of the (mock) player.
class PlayerState {
  final Track? track;
  final bool isPlaying;
  final Duration position;
  final bool shuffle;
  final LoopMode repeat;

  const PlayerState({
    this.track,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.shuffle = false,
    this.repeat = LoopMode.off,
  });

  Duration get duration => track?.duration ?? Duration.zero;

  /// 0.0–1.0 progress through the current track.
  double get progress {
    final total = duration.inMilliseconds;
    if (total <= 0) return 0;
    return (position.inMilliseconds / total).clamp(0.0, 1.0);
  }

  bool get hasTrack => track != null;

  PlayerState copyWith({
    Track? track,
    bool? isPlaying,
    Duration? position,
    bool? shuffle,
    LoopMode? repeat,
  }) {
    return PlayerState(
      track: track ?? this.track,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      shuffle: shuffle ?? this.shuffle,
      repeat: repeat ?? this.repeat,
    );
  }
}

enum LoopMode { off, all, one }

/// Mock player: no real audio. A 1-second [Timer] advances [PlayerState.position]
/// while playing, so the UI scrubber/mini-player animate realistically. Logic is
/// isolated here so a real `just_audio` engine can replace it without UI changes.
class PlayerController extends Notifier<PlayerState> {
  Timer? _ticker;

  /// The queue the current track was started from (defaults to Sunday Slice).
  List<Track> _queue = MockData.sundaySliceTracks;

  @override
  PlayerState build() {
    // Seed with the design's default now-playing track, paused at the start.
    ref.onDispose(_stopTicker);
    return PlayerState(track: MockData.nowPlayingDefault);
  }

  /// Start (or restart) playback of [track], optionally setting the queue it
  /// belongs to so next/prev can walk it.
  void play(Track track, {List<Track>? queue}) {
    if (queue != null) _queue = queue;
    state = state.copyWith(track: track, position: Duration.zero, isPlaying: true);
    _startTicker();
  }

  void toggle() {
    if (!state.hasTrack) return;
    final playing = !state.isPlaying;
    state = state.copyWith(isPlaying: playing);
    playing ? _startTicker() : _stopTicker();
  }

  void seek(Duration position) {
    final clamped = position < Duration.zero
        ? Duration.zero
        : (position > state.duration ? state.duration : position);
    state = state.copyWith(position: clamped);
  }

  /// Seek by a 0.0–1.0 fraction of the track (scrubber drag).
  void seekFraction(double fraction) {
    final ms = (state.duration.inMilliseconds * fraction.clamp(0.0, 1.0)).round();
    seek(Duration(milliseconds: ms));
  }

  void next() => _step(1);
  void previous() => _step(-1);

  void toggleShuffle() => state = state.copyWith(shuffle: !state.shuffle);

  void cycleRepeat() {
    final next = LoopMode.values[(state.repeat.index + 1) % LoopMode.values.length];
    state = state.copyWith(repeat: next);
  }

  void _step(int delta) {
    if (_queue.isEmpty || state.track == null) return;
    final i = _queue.indexWhere((t) => t.id == state.track!.id);
    if (i == -1) return;
    final n = (i + delta) % _queue.length;
    final index = n < 0 ? n + _queue.length : n;
    play(_queue[index], queue: _queue);
  }

  void _startTicker() {
    _stopTicker();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _tick() {
    final next = state.position + const Duration(seconds: 1);
    if (next >= state.duration) {
      // Reached the end — advance or loop.
      switch (state.repeat) {
        case LoopMode.one:
          state = state.copyWith(position: Duration.zero);
        case LoopMode.off:
        case LoopMode.all:
          next < state.duration
              ? state = state.copyWith(position: next)
              : this.next();
      }
      return;
    }
    state = state.copyWith(position: next);
  }
}

final playerProvider =
    NotifierProvider<PlayerController, PlayerState>(PlayerController.new);
