import '../models/song.dart';

/// A candidate [Song] paired with its computed recommendation [score].
/// Ported from Kotlin `domain.autoplay.ScoredSong`.
class ScoredSong {
  final Song song;
  final double score;
  const ScoredSong(this.song, this.score);
}
