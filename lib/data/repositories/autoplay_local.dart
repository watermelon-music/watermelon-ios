import 'package:drift/drift.dart' show Value;

import '../../domain/autoplay/autoplay_signals.dart';
import '../../domain/models/song.dart';
import '../local/app_database.dart' as db;

int _wallClock() => DateTime.now().millisecondsSinceEpoch;

Song _favoriteToSong(db.UserAction a) => Song(
      id: a.songId,
      title: a.songTitle,
      artistId: '',
      artistName: a.songArtist,
      albumName: a.albumName,
      durationMs: a.durationMs,
      coverUrl: a.songCoverUrl,
      audioUrl: a.audioUrl,
      genre: a.genre,
    );

Song _historyToSong(db.PlayHistoryData h) => Song(
      id: h.songId,
      title: h.songTitle,
      artistId: '',
      artistName: h.songArtist,
      coverUrl: h.songCoverUrl,
      audioUrl: h.audioUrl,
    );

/// Reads autoplay signals (favorites, skips, recent plays) from the local DB.
class DriftAutoplaySignalSource implements AutoplaySignalSource {
  final db.AppDatabase _db;
  const DriftAutoplaySignalSource(this._db);

  @override
  Future<List<Song>> favorites() async =>
      (await _db.getFavorites()).map(_favoriteToSong).toList();

  @override
  Future<Set<String>> skippedSongIds() => _db.getSkippedIds();

  @override
  Future<List<Song>> recentPlays() async =>
      (await _db.getRecentPlays()).map(_historyToSong).toList();
}

/// Records autoplay analytics (plays, skips, transitions) to the local DB.
/// Ported from Kotlin `AutoplayRepositoryImpl`'s TransitionTracker methods.
class DriftAutoplayAnalytics implements AutoplayAnalytics {
  final db.AppDatabase _db;
  final int Function() _now;

  DriftAutoplayAnalytics(this._db, {this._now = _wallClock});

  @override
  Future<void> recordPlayStart(Song song, String source) {
    return _db.insertPlay(db.PlayHistoryCompanion.insert(
      songId: song.id,
      songTitle: song.title,
      songArtist: song.artistName,
      songCoverUrl: Value(song.coverUrl),
      audioUrl: Value(song.audioUrl),
      source: Value(source),
      playedAt: _now(),
    ));
  }

  @override
  Future<void> recordSkip(Song song, String context) {
    return _db.insertSkip(db.SkipsCompanion.insert(
      songId: song.id,
      songTitle: song.title,
      songArtist: song.artistName,
      skippedAt: _now(),
      context: Value(context),
    ));
  }

  @override
  Future<void> recordTransition(String fromSongId, String toSongId) =>
      _db.recordTransition(fromSongId, toSongId, _now());

  @override
  Future<void> clearAll() async {
    await _db.clearPlayHistory();
    await _db.clearSkips();
    await _db.clearTransitions();
  }
}
