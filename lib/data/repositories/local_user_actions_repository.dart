import 'package:drift/drift.dart' show Value;

import '../../core/result.dart';
import '../../domain/models/song.dart';
import '../../domain/repositories/user_actions_repository.dart';
import '../local/app_database.dart' as db;

int _wallClock() => DateTime.now().millisecondsSinceEpoch;

/// Local (offline-first) implementation of [UserActionsRepository].
///
/// Favorites and recently-played are persisted to the local DB immediately.
/// Supabase sync (the `syncedToServer` flag) is wired in P4; for now everything
/// stays local.
class LocalUserActionsRepository implements UserActionsRepository {
  final db.AppDatabase _db;
  final int Function() _now;

  LocalUserActionsRepository(this._db, {this._now = _wallClock});

  Song _toSong(db.UserAction a) => Song(
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

  db.UserActionsCompanion _companion(Song song, String actionType) =>
      db.UserActionsCompanion.insert(
        songId: song.id,
        actionType: actionType,
        songTitle: song.title,
        songArtist: song.artistName,
        songCoverUrl: Value(song.coverUrl),
        audioUrl: Value(song.audioUrl),
        durationMs: Value(song.durationMs),
        albumName: Value(song.albumName),
        genre: Value(song.genre),
        createdAt: _now(),
      );

  @override
  Stream<List<Song>> getFavorites() =>
      _db.watchFavorites().map((rows) => rows.map(_toSong).toList());

  @override
  Stream<List<Song>> getRecentlyPlayed() =>
      _db.watchRecentlyPlayed().map((rows) => rows.map(_toSong).toList());

  @override
  Future<Result<Unit>> addToFavorites(Song song) => Result.guard(() async {
        await _db.upsertUserAction(_companion(song, 'favorite'));
        return Unit.unit;
      });

  @override
  Future<Result<Unit>> removeFromFavorites(String songId) =>
      Result.guard(() async {
        await _db.removeFavorite(songId);
        return Unit.unit;
      });

  @override
  Future<Result<Unit>> recordRecentlyPlayed(Song song) =>
      Result.guard(() async {
        await _db.upsertUserAction(_companion(song, 'recent'));
        await _db.trimRecentActions();
        return Unit.unit;
      });
}
