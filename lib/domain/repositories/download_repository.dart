import '../../core/result.dart';
import '../models/downloaded_song.dart';
import '../models/song.dart';

/// Offline downloads (local only — not synced).
/// Ported from Kotlin `domain.repository.DownloadRepository`.
abstract class DownloadRepository {
  Stream<List<DownloadedSong>> getDownloads();
  Future<Result<Unit>> downloadSong(Song song, String url);
  Future<Result<Unit>> recordDownload(Song song, String filePath, int fileSize);
  Future<Result<Unit>> deleteDownload(String songId);

  /// Remove DB rows whose backing files no longer exist.
  Future<Result<Unit>> cleanupMissingFiles();
  Future<bool> isDownloaded(String songId);
  Future<String?> getDownloadPath(String songId);
}
