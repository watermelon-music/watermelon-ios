import '../models/song.dart';

/// Read access to the user signals the recommendation engine scores against.
///
/// Backed by the local analytics DB (Drift, arriving in P3). Kept as an
/// interface so the engine stays pure and testable with in-memory fakes.
abstract class AutoplaySignalSource {
  /// Liked songs (used as candidates and to derive favorite-artist names).
  Future<List<Song>> favorites();

  /// Ids of songs the user has skipped (scored with a penalty).
  Future<Set<String>> skippedSongIds();

  /// Recently played songs, **most-recent first** (drives recency decay and
  /// recent-artist candidate search).
  Future<List<Song>> recentPlays();
}

/// Write access for analytics events that feed future recommendations.
/// Ported from Kotlin `domain.autoplay.TransitionTracker`.
abstract class AutoplayAnalytics {
  Future<void> recordPlayStart(Song song, String source);
  Future<void> recordSkip(Song song, String context);
  Future<void> recordTransition(String fromSongId, String toSongId);
  Future<void> clearAll();
}
