import '../utils/format.dart';

/// A single playable track. `art` is an asset path (see AppAssets).
class Track {
  final String id;
  final String title;
  final String artist;
  final String art;
  final Duration duration;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.art,
    required this.duration,
  });

  /// `m:ss` label for the track duration.
  String get durationLabel => formatDuration(duration);

  @override
  bool operator ==(Object other) => other is Track && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
