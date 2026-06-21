import 'package:drift/drift.dart' show Value;

import '../../core/result.dart';
import '../../domain/models/downloaded_song.dart';
import '../../domain/models/song.dart';
import '../../domain/repositories/download_repository.dart';
import '../local/app_database.dart' as db;

int _wallClock() => DateTime.now().millisecondsSinceEpoch;

/// Local download metadata store.
///
/// The download *registry* (what's offline + where) lives here. Actually
/// fetching bytes to disk and removing files is platform work that lands in P2;
/// [downloadSong] therefore reports unimplemented for now, while
/// [recordDownload] (called once a file exists) is fully functional.
class DownloadRepositoryImpl implements DownloadRepository {
  final db.AppDatabase _db;
  final int Function() _now;

  DownloadRepositoryImpl(this._db, {this._now = _wallClock});

  DownloadedSong _toDomain(db.DownloadedSong d) => DownloadedSong(
        songId: d.songId,
        title: d.title,
        artist: d.artist,
        coverUrl: d.coverUrl,
        localFilePath: d.localFilePath,
        fileSize: d.fileSize,
        downloadedAt: d.downloadedAt,
      );

  @override
  Stream<List<DownloadedSong>> getDownloads() =>
      _db.watchDownloads().map((rows) => rows.map(_toDomain).toList());

  @override
  Future<Result<Unit>> downloadSong(Song song, String url) async => Err(
        UnimplementedError('File download lands in P2 (just_audio/dio). Use '
            'recordDownload once the file is on disk.'),
      );

  @override
  Future<Result<Unit>> recordDownload(
    Song song,
    String filePath,
    int fileSize,
  ) =>
      Result.guard(() async {
        await _db.upsertDownload(db.DownloadedSongsCompanion.insert(
          songId: song.id,
          title: song.title,
          artist: song.artistName,
          coverUrl: Value(song.coverUrl),
          localFilePath: filePath,
          fileSize: Value(fileSize),
          downloadedAt: _now(),
        ));
        return Unit.unit;
      });

  @override
  Future<Result<Unit>> deleteDownload(String songId) => Result.guard(() async {
        await _db.deleteDownload(songId);
        return Unit.unit;
      });

  @override
  Future<Result<Unit>> cleanupMissingFiles() async {
    // File existence checks require dart:io (P2). No-op for now.
    return const Ok(Unit.unit);
  }

  @override
  Future<bool> isDownloaded(String songId) async =>
      (await _db.getDownload(songId)) != null;

  @override
  Future<String?> getDownloadPath(String songId) async =>
      (await _db.getDownload(songId))?.localFilePath;
}
