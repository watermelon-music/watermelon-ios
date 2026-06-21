import '../../core/result.dart';
import '../models/playlist.dart';
import '../models/song.dart';

/// User playlists (local cache + Supabase sync).
/// Ported from Kotlin `domain.repository.PlaylistRepository`.
abstract class PlaylistRepository {
  Stream<List<Playlist>> getUserPlaylists();
  Future<Result<Unit>> refresh();
  Future<Result<Playlist>> createPlaylist(
    String name, {
    String? description,
    String? coverUrl,
  });
  Future<Result<Unit>> addSongToPlaylist(String playlistId, Song song);
  Future<Result<Unit>> removeSongFromPlaylist(String playlistId, String songId);
  Future<Result<Unit>> deletePlaylist(String playlistId);

  /// Returns a share code for the playlist.
  Future<Result<String>> sharePlaylist(String playlistId);
  Future<Result<Unit>> editPlaylist(
    String playlistId,
    String name, {
    String? description,
  });
  Future<Result<Playlist>> getPlaylistById(String playlistId);
}
