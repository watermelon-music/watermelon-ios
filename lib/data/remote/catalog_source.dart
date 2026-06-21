import 'package:dio/dio.dart';

import '../../domain/models/song.dart';

/// A remote music catalog (Watermelon backend, Jamendo, Audius, …).
///
/// The [MusicCatalogRepository] queries sources in priority order and uses the
/// first that returns results. A source returns an empty list (not an error)
/// when it doesn't support an operation or has nothing to offer.
abstract class CatalogSource {
  String get name;
  Future<List<Song>> search(String query);
  Future<List<Song>> trending();
  Future<List<Song>> byGenre(String genre);
}

/// Build a configured [Dio] for a catalog source.
Dio createDio(
  String baseUrl, {
  Duration timeout = const Duration(seconds: 15),
}) {
  return Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: timeout,
    receiveTimeout: timeout,
  ));
}

/// Parse a duration that may be seconds (int/num) or `"MM:SS"` / `"HH:MM:SS"`
/// into milliseconds. Returns 0 when unparseable.
int parseDurationToMs(dynamic raw) {
  if (raw == null) return 0;
  if (raw is num) return (raw * 1000).round();
  final s = raw.toString().trim();
  if (s.isEmpty) return 0;
  final asNum = num.tryParse(s);
  if (asNum != null) return (asNum * 1000).round();
  final parts = s.split(':').map((p) => int.tryParse(p) ?? 0).toList();
  var seconds = 0;
  for (final p in parts) {
    seconds = seconds * 60 + p;
  }
  return seconds * 1000;
}
