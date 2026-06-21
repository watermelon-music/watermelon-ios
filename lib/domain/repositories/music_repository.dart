import '../models/playlist.dart';
import '../models/song.dart';

/// Aggregated music feeds for the home surface.
/// Ported from Kotlin `domain.repository.MusicRepository`.
abstract class MusicRepository {
  Stream<List<Song>> getRecentlyPlayed();
  Stream<List<Song>> getFavorites();
  Stream<List<Song>> getTrendingMusic();
  Stream<List<Playlist>> getRecommendedPlaylists();
}
