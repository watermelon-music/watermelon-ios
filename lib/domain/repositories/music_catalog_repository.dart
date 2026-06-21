import '../models/song.dart';

/// External online catalog (YouTube/Watermelon/Jamendo/Audius). Nothing stored
/// locally. Ported from Kotlin `domain.repository.MusicCatalogRepository`.
abstract class MusicCatalogRepository {
  Stream<List<Song>> getTrendingMusic();
  Stream<List<Song>> search(String query);
  Stream<List<Song>> getSongsByGenre(String genre);
}
