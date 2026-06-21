import '../../core/result.dart';

/// Lyrics lookup (LRClib). Ported from Kotlin
/// `domain.repository.LyricsRepository`.
abstract class LyricsRepository {
  Future<Result<String>> getLyrics(String artist, String title);
}
