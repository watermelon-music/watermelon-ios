import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../domain/models/song.dart';
import '../catalog_source.dart';

/// YouTube as a catalog source via on-device extraction (`youtube_explode_dart`
/// — the Dart equivalent of yt-dlp / NewPipe). Search returns videos as [Song]s
/// keyed by the 11-char videoId; the playable audio URL is resolved lazily at
/// play time by [YoutubeUrlExtractor] (Google Video URLs expire ~quickly).
///
/// `audioUrl` is intentionally left null here — we keep the canonical
/// `youtube.com/watch?v=<id>` only implicitly (the id), and resolve streams on
/// demand so they don't go stale sitting in a list.
class YoutubeSource implements CatalogSource {
  final YoutubeExplode _yt;
  const YoutubeSource(this._yt);

  @override
  String get name => 'youtube';

  @override
  Future<List<Song>> search(String query) => _searchSongs(query);

  /// YouTube has no public "trending music" list via the extractor, so the Home
  /// row is seeded from a popular-music query and then content-filtered upstream.
  @override
  Future<List<Song>> trending() => _searchSongs('top music hits 2026');

  @override
  Future<List<Song>> byGenre(String genre) => _searchSongs('$genre music');

  Future<List<Song>> _searchSongs(String query) async {
    final results = await _yt.search.search(query);
    return [for (final v in results) _toSong(v)];
  }

  Song _toSong(Video v) {
    final id = v.id.value;
    return Song(
      id: id,
      title: v.title,
      artistId: v.channelId.value,
      artistName: v.author,
      durationMs: v.duration?.inMilliseconds ?? 0,
      // highRes is reliably present; fall back to YouTube's canonical thumb.
      coverUrl: v.thumbnails.highResUrl.isNotEmpty
          ? v.thumbnails.highResUrl
          : 'https://i.ytimg.com/vi/$id/hqdefault.jpg',
      audioUrl: null, // resolved on demand by YoutubeUrlExtractor
    );
  }
}
