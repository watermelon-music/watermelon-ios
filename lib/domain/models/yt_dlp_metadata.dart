/// Extracted source metadata used to power recommendations.
/// Ported from Kotlin `domain.model.YtDlpMetadata`.
class YtDlpMetadata {
  final String id;
  final String title;
  final String? artist;
  final String? channel;
  final List<String> tags;
  final List<String> categories;
  final int? durationSec;
  final String? description;

  const YtDlpMetadata({
    required this.id,
    required this.title,
    this.artist,
    this.channel,
    this.tags = const [],
    this.categories = const [],
    this.durationSec,
    this.description,
  });
}
