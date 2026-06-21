import 'dart:collection';

import '../models/song.dart';
import 'autoplay_signals.dart';
import 'recommendation_engine.dart';

/// Public autoplay API: returns the next song to play after the queue runs low.
///
/// Wraps [RecommendationEngine] with a FIFO cache and analytics recording.
/// Ported from Kotlin `AutoplayRepositoryImpl` — see
/// `LOGIC_IMPLEMENTATION.md` §6.4. The cache holds [batchSize] songs and refills
/// once it drops below [refillThreshold]; it is cleared whenever the current
/// song changes.
class AutoplayEngine implements AutoplayAnalytics {
  static const int batchSize = 20;
  static const int refillThreshold = 10;

  final RecommendationEngine _engine;
  final AutoplaySignalSource _signals;
  final AutoplayAnalytics _analytics;

  /// Whether autoplay is enabled (persisted preference, injected).
  final bool Function() isEnabled;

  final Queue<Song> _cache = Queue<Song>();
  String? _lastCurrentSongId;

  AutoplayEngine(
    this._engine,
    this._signals,
    this._analytics, {
    required this.isEnabled,
  });

  /// The next recommended song, or null if autoplay is off or nothing fits.
  Future<Song?> findNextSong(
    Song currentSong, {
    Set<String> excludeIds = const {},
  }) async {
    if (!isEnabled()) return null;

    // Invalidate cache when the seed song changes.
    if (_lastCurrentSongId != null && _lastCurrentSongId != currentSong.id) {
      _cache.clear();
      _engine.invalidateCache();
    }
    _lastCurrentSongId = currentSong.id;

    final recent = await _signals.recentPlays();
    final excludeSet = {
      ...excludeIds,
      currentSong.id,
      ...recent.map((s) => s.id),
    };

    if (_cache.length < refillThreshold) {
      final fresh = await _engine.generateQueue(
        currentSong: currentSong,
        excludeIds: {...excludeSet, ..._cache.map((s) => s.id)},
        count: batchSize,
      );
      _cache.addAll(fresh);
    }

    while (_cache.isNotEmpty) {
      final candidate = _cache.removeFirst();
      if (!excludeSet.contains(candidate.id)) return candidate;
    }
    return null;
  }

  // ── AutoplayAnalytics (delegated, plus cache reset on clearAll) ────────────

  @override
  Future<void> recordPlayStart(Song song, String source) =>
      _analytics.recordPlayStart(song, source);

  @override
  Future<void> recordSkip(Song song, String context) =>
      _analytics.recordSkip(song, context);

  @override
  Future<void> recordTransition(String fromSongId, String toSongId) =>
      _analytics.recordTransition(fromSongId, toSongId);

  @override
  Future<void> clearAll() async {
    await _analytics.clearAll();
    _cache.clear();
    _engine.invalidateCache();
    _lastCurrentSongId = null;
  }
}
