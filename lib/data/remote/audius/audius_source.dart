import 'package:dio/dio.dart';

import '../../../domain/models/song.dart';
import '../catalog_source.dart';

/// Audius — decentralized, no-auth catalog (see LOGIC_IMPLEMENTATION.md §4.3).
/// Good for trending; stream URLs are the `/stream` redirect endpoint.
class AudiusSource implements CatalogSource {
  final Dio _dio;
  final String appName;
  final String host;

  const AudiusSource(
    this._dio, {
    this.appName = 'watermelon',
    this.host = 'https://discoveryprovider.audius.co',
  });

  @override
  String get name => 'audius';

  @override
  Future<List<Song>> search(String query) async {
    final r = await _dio.get<dynamic>('v1/tracks/search',
        queryParameters: {'query': query, 'app_name': appName});
    return _parse(r.data);
  }

  @override
  Future<List<Song>> trending() async {
    final r = await _dio.get<dynamic>('v1/tracks/trending',
        queryParameters: {'app_name': appName});
    return _parse(r.data);
  }

  @override
  Future<List<Song>> byGenre(String genre) async {
    final r = await _dio.get<dynamic>('v1/tracks/trending',
        queryParameters: {'genre': genre, 'app_name': appName});
    return _parse(r.data);
  }

  List<Song> _parse(dynamic data) {
    final list = (data is Map ? data['data'] : null) ?? const [];
    return [
      for (final e in (list as List))
        if (e is Map) _toSong(e.cast<String, dynamic>()),
    ];
  }

  Song _toSong(Map<String, dynamic> j) {
    final id = (j['id'] ?? '').toString();
    final user = j['user'];
    final artwork = j['artwork'];
    return Song(
      id: id,
      title: (j['title'] ?? '').toString(),
      artistId: (user is Map ? user['id'] : '')?.toString() ?? '',
      artistName: (user is Map ? (user['name'] ?? '') : '').toString(),
      durationMs: parseDurationToMs(j['duration']),
      coverUrl: artwork is Map
          ? (artwork['480x480'] ?? artwork['150x150'])?.toString()
          : null,
      audioUrl: '$host/v1/tracks/$id/stream?app_name=$appName',
      genre: (j['genre'])?.toString(),
    );
  }
}
