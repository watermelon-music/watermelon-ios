import 'package:dio/dio.dart';

import '../../../domain/models/song.dart';
import '../catalog_source.dart';

/// Jamendo — creative-commons catalog (see LOGIC_IMPLEMENTATION.md §4.4).
/// Requires a `client_id`; `audio` field is a directly playable stream URL.
class JamendoSource implements CatalogSource {
  final Dio _dio;
  final String clientId;

  const JamendoSource(this._dio, {required this.clientId});

  @override
  String get name => 'jamendo';

  Map<String, dynamic> _base() => {
        'client_id': clientId,
        'format': 'json',
        'limit': '30',
        'include': 'musicinfo',
      };

  @override
  Future<List<Song>> search(String query) async {
    if (clientId.isEmpty) return const [];
    final r = await _dio.get<dynamic>('tracks',
        queryParameters: {..._base(), 'search': query});
    return _parse(r.data);
  }

  @override
  Future<List<Song>> trending() async {
    if (clientId.isEmpty) return const [];
    final r = await _dio.get<dynamic>('tracks',
        queryParameters: {..._base(), 'order': 'popularity_total'});
    return _parse(r.data);
  }

  @override
  Future<List<Song>> byGenre(String genre) async {
    if (clientId.isEmpty) return const [];
    final r = await _dio.get<dynamic>('tracks',
        queryParameters: {..._base(), 'tags': genre});
    return _parse(r.data);
  }

  List<Song> _parse(dynamic data) {
    final list = (data is Map ? data['results'] : null) ?? const [];
    return [
      for (final e in (list as List))
        if (e is Map) _toSong(e.cast<String, dynamic>()),
    ];
  }

  Song _toSong(Map<String, dynamic> j) {
    final musicinfo = j['musicinfo'];
    final tags = musicinfo is Map ? musicinfo['tags'] : null;
    final genres = tags is Map ? tags['genres'] : null;
    final genre =
        (genres is List && genres.isNotEmpty) ? genres.first.toString() : null;
    return Song(
      id: (j['id'] ?? '').toString(),
      title: (j['name'] ?? '').toString(),
      artistId: (j['artist_id'] ?? '').toString(),
      artistName: (j['artist_name'] ?? '').toString(),
      albumName: (j['album_name'])?.toString(),
      durationMs: parseDurationToMs(j['duration']),
      coverUrl: (j['album_image'] ?? j['image'])?.toString(),
      audioUrl: (j['audio'])?.toString(),
      genre: genre,
    );
  }
}
