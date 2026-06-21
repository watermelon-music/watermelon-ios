import 'package:dio/dio.dart';

import '../../config/app_constants.dart';
import '../../core/result.dart';
import '../../domain/models/yt_dlp_metadata.dart';
import '../../domain/repositories/url_extractor_repository.dart';

int _wallClock() => DateTime.now().millisecondsSinceEpoch;

class _CachedUrl {
  final String url;
  final int at;
  const _CachedUrl(this.url, this.at);
}

/// Resolves YouTube source URLs/ids into playable audio URLs via the Watermelon
/// backend's yt-dlp extraction endpoint (project decision: yt-dlp based).
///
/// Google Video URLs expire quickly, so results are cached for
/// [AppConstants.extractionUrlCacheTtl] (10 min) and can be force-refreshed via
/// [invalidateCache]. Response shape is parsed tolerantly (see §4.1/§4.2).
class UrlExtractorRepositoryImpl implements UrlExtractorRepository {
  final Dio _dio;
  final int Function() _now;
  final Map<String, _CachedUrl> _cache = {};

  UrlExtractorRepositoryImpl(this._dio, {this._now = _wallClock});

  /// Extract the 11-char YouTube video id from a URL, or return the input if it
  /// already looks like a bare id.
  static String? videoId(String sourceUrl) {
    final match = RegExp(r'([a-zA-Z0-9_-]{11})').firstMatch(sourceUrl);
    return match?.group(1);
  }

  @override
  Future<Result<String>> extractAudioUrl(String sourceUrl) async {
    final id = videoId(sourceUrl) ?? sourceUrl;

    final cached = _cache[id];
    if (cached != null &&
        _now() - cached.at < AppConstants.extractionUrlCacheTtl.inMilliseconds) {
      return Ok(cached.url);
    }

    return Result.guard(() async {
      final r = await _dio.get<dynamic>('stream', queryParameters: {'id': id});
      final url = _extractUrl(r.data);
      if (url == null || url.isEmpty) {
        throw StateError('No stream URL in response for "$id"');
      }
      _cache[id] = _CachedUrl(url, _now());
      return url;
    });
  }

  @override
  Future<Result<YtDlpMetadata>> extractMetadata(String sourceUrl) async {
    final id = videoId(sourceUrl) ?? sourceUrl;
    return Result.guard(() async {
      final r = await _dio.get<dynamic>('getSong', queryParameters: {'id': id});
      final j = (r.data is Map)
          ? (r.data as Map).cast<String, dynamic>()
          : <String, dynamic>{};
      return YtDlpMetadata(
        id: id,
        title: (j['title'] ?? '').toString(),
        artist: (j['artist'] ?? j['author'])?.toString(),
        channel: (j['channel'])?.toString(),
        tags: _stringList(j['tags']),
        categories: _stringList(j['categories']),
        durationSec: j['duration'] is num ? (j['duration'] as num).round() : null,
        description: (j['description'])?.toString(),
      );
    });
  }

  @override
  void invalidateCache(String sourceUrl) {
    final id = videoId(sourceUrl) ?? sourceUrl;
    _cache.remove(id);
  }

  String? _extractUrl(dynamic data) {
    if (data is String) return data;
    if (data is Map) {
      return (data['url'] ??
              data['stream'] ??
              data['streamUrl'] ??
              data['audioUrl'] ??
              data['audio'])
          ?.toString();
    }
    return null;
  }

  List<String> _stringList(dynamic raw) =>
      raw is List ? raw.map((e) => e.toString()).toList() : const [];
}
