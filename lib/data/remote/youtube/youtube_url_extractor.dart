import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../core/app_logger.dart';
import '../../../core/result.dart';
import '../../../domain/models/yt_dlp_metadata.dart';
import '../../../domain/repositories/url_extractor_repository.dart';

/// Resolves a YouTube video id → a **playable local file** on-device via
/// `youtube_explode_dart` (the yt-dlp/NewPipe equivalent).
///
/// Why download instead of returning the googlevideo URL: iOS's AVPlayer can't
/// stream googlevideo progressive URLs reliably (range/throttle quirks cause it
/// to play a few seconds then go silent while the clock keeps running). Fetching
/// the complete AAC/M4A to a temp cache via youtube_explode's own `get()` — which
/// handles googlevideo's chunking/throttling correctly — yields a complete local
/// file that AVPlayer plays start-to-finish. Files are cached per videoId for the
/// session (reused on replay); the OS reclaims the temp dir.
class YoutubeUrlExtractor implements UrlExtractorRepository {
  final YoutubeExplode _yt;
  final Set<String> _invalidated = {};

  YoutubeUrlExtractor(this._yt);

  /// Extract the 11-char YouTube video id from a URL/bare id.
  static String? videoId(String sourceUrl) {
    final match = RegExp(
      r'(?:youtube\.com/(?:watch\?(?:[^&]*&)*v=|shorts/|live/|embed/|v/)|youtu\.be/)([a-zA-Z0-9_-]{11})',
    ).firstMatch(sourceUrl);
    if (match != null) return match.group(1);
    final bare = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    return bare.hasMatch(sourceUrl) ? sourceUrl : null;
  }

  @override
  Future<Result<String>> extractAudioUrl(String sourceUrl) async {
    final id = videoId(sourceUrl) ?? sourceUrl;
    return Result.guard(() async {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/yt_$id.m4a');

      // Reuse a previously-cached file unless it was invalidated.
      if (!_invalidated.contains(id) &&
          file.existsSync() &&
          await file.length() > 0) {
        return file.uri.toString(); // file:///...
      }
      _invalidated.remove(id);

      final manifest = await _yt.videos.streamsClient.getManifest(id);
      final audio = manifest.audioOnly;
      if (audio.isEmpty) throw StateError('No audio-only stream for "$id"');
      final chosen = _bestPlayableAudio(audio);
      AppLog.boot('yt.extract', {
        'id': id,
        'codec': chosen.audioCodec,
        'kbps': chosen.bitrate.kiloBitsPerSecond.round(),
        'bytes': chosen.size.totalBytes,
      });

      final part = File('${dir.path}/yt_$id.part');
      await _downloadChunked(chosen.url, chosen.size.totalBytes, part);
      await part.rename(file.path);
      AppLog.boot('yt.cached', {'id': id, 'bytes': await file.length()});
      return file.uri.toString();
    });
  }

  @override
  Future<Result<YtDlpMetadata>> extractMetadata(String sourceUrl) async {
    final id = videoId(sourceUrl) ?? sourceUrl;
    return Result.guard(() async {
      final v = await _yt.videos.get(id);
      return YtDlpMetadata(
        id: id,
        title: v.title,
        artist: v.author,
        channel: v.author,
        tags: v.keywords,
        categories: const [],
        durationSec: v.duration?.inSeconds,
        description: v.description,
      );
    });
  }

  /// Downloads [total] bytes of [url] to [out] in 1 MiB range-query chunks.
  /// googlevideo throttles a single sequential download to ~playback speed, but
  /// each `range=` request resets the throttle, so chunking downloads at full
  /// speed. Each chunk retries transient failures; we never advance past a gap.
  Future<void> _downloadChunked(Uri url, int total, File out) async {
    const chunk = 1 << 20; // 1 MiB
    const userAgent =
        'Mozilla/5.0 (Linux; Android 14; SM-S918B) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/125.0.0.0 Mobile Safari/537.36';
    final client = HttpClient()..userAgent = userAgent;
    final sink = out.openWrite();
    try {
      var pos = 0;
      while (pos < total) {
        final upper = (pos + chunk - 1) >= total ? total - 1 : pos + chunk - 1;
        var got = 0;
        for (var attempt = 0; attempt < 4 && got == 0; attempt++) {
          try {
            final ranged = url.replace(queryParameters: {
              ...url.queryParameters,
              'range': '$pos-$upper',
            });
            final req = await client.getUrl(ranged);
            req.headers.set(HttpHeaders.userAgentHeader, userAgent);
            final resp = await req.close();
            if (resp.statusCode >= 400) {
              throw HttpException('googlevideo ${resp.statusCode}');
            }
            await for (final bytes in resp) {
              sink.add(bytes);
              got += bytes.length;
            }
          } catch (_) {
            got = 0; // retry this chunk
          }
        }
        if (got == 0) {
          throw StateError('download stalled at $pos/$total');
        }
        pos += got;
      }
    } finally {
      await sink.flush();
      await sink.close();
      client.close();
    }
  }

  /// Pick the highest-bitrate **AAC/M4A** audio stream — iOS's AVPlayer (and
  /// thus just_audio) can't decode YouTube's Opus/WebM streams, which is what
  /// `withHighestBitrate()` usually returns. Falls back to highest overall.
  AudioOnlyStreamInfo _bestPlayableAudio(List<AudioOnlyStreamInfo> audio) {
    final mp4 = audio.where((s) => s.container.name == 'mp4').toList();
    if (mp4.isNotEmpty) {
      return mp4.reduce((a, b) =>
          a.bitrate.bitsPerSecond >= b.bitrate.bitsPerSecond ? a : b);
    }
    return audio.withHighestBitrate();
  }

  @override
  void invalidateCache(String sourceUrl) {
    final id = videoId(sourceUrl) ?? sourceUrl;
    _invalidated.add(id); // force a fresh download next resolve
  }
}
