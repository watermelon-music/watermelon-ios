import 'package:dio/dio.dart';

import '../../../domain/models/song.dart';
import '../catalog_source.dart';

/// The Watermelon backend (yt-dlp powered) — primary catalog source.
/// Returns YouTube-backed results. Endpoint shapes are tolerant since the exact
/// JSON is finalized server-side (see LOGIC_IMPLEMENTATION.md §4.1).
class WatermelonSource implements CatalogSource {
  final Dio _dio;
  const WatermelonSource(this._dio);

  @override
  String get name => 'watermelon';

  @override
  Future<List<Song>> search(String query) async {
    final r = await _dio.get<dynamic>('search', queryParameters: {'q': query});
    return _parse(r.data);
  }

  /// The backend has no trending endpoint; trending falls through to Audius.
  @override
  Future<List<Song>> trending() async => const [];

  @override
  Future<List<Song>> byGenre(String genre) async {
    final r = await _dio.get<dynamic>('search', queryParameters: {'q': genre});
    return _parse(r.data);
  }

  List<Song> _parse(dynamic data) {
    final list = data is List
        ? data
        : (data is Map
            ? (data['results'] ?? data['data'] ?? data['songs'] ?? const [])
            : const []);
    return [
      for (final e in (list as List))
        if (e is Map) _toSong(e.cast<String, dynamic>()),
    ];
  }

  Song _toSong(Map<String, dynamic> j) {
    final id =
        (j['id'] ?? j['videoId'] ?? j['video_id'] ?? '').toString();
    final cover = (j['cover'] ??
            j['coverUrl'] ??
            j['thumbnail'] ??
            (id.isNotEmpty
                ? 'https://i.ytimg.com/vi/$id/maxresdefault.jpg'
                : null))
        ?.toString();
    return Song(
      id: id,
      title: (j['title'] ?? '').toString(),
      artistId: '',
      artistName: (j['artist'] ?? j['channel'] ?? j['author'] ?? '').toString(),
      durationMs: parseDurationToMs(j['duration']),
      coverUrl: cover,
      audioUrl: (j['stream'] ?? j['audioUrl'] ?? j['url'])?.toString(),
    );
  }
}
