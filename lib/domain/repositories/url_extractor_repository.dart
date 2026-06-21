import '../../core/result.dart';
import '../models/yt_dlp_metadata.dart';

/// Resolves a source (e.g. YouTube) URL into a playable audio URL + metadata.
///
/// Ported from Kotlin `domain.repository.UrlExtractorRepository`. Per project
/// decision the Flutter implementation is yt-dlp-based (via the Watermelon
/// backend's yt-dlp extraction endpoint).
abstract class UrlExtractorRepository {
  Future<Result<String>> extractAudioUrl(String sourceUrl);
  Future<Result<YtDlpMetadata>> extractMetadata(String sourceUrl);
  void invalidateCache(String sourceUrl);
}
