/// Scoring weights for the recommendation engine.
///
/// Ported verbatim from the Kotlin `RecommendationEngineImpl.Weights` (the
/// values the impl actually uses — see `LOGIC_IMPLEMENTATION.md` §6.1). The
/// source split sums to 100 (40/30/20/10) before bonuses/penalties.
class RecommendationWeights {
  /// Candidate surfaced by searching the current artist.
  final double relatedArtist;

  /// Candidate from the same genre.
  final double sameGenre;

  /// Candidate from the user's favorites / recently-played artists.
  final double userHistory;

  /// Candidate from trending discovery.
  final double randomDiscovery;

  /// Candidate matched via title-word ("hashtag") search.
  final double hashtagSemantic;

  /// Bonus when the candidate shares the current song's artist.
  final double sameArtistBonus;

  /// Bonus when the candidate's artist is in the user's favorites.
  final double favoriteArtistBonus;

  /// Penalty subtracted when the candidate has been skipped.
  final double skipPenalty;

  /// Maximum recency-decay penalty (scaled linearly by play position).
  final double recencyDecayBase;

  /// Hard filter: drop candidates whose normalized title similarity to the
  /// current song exceeds this (kills remixes/edits/duplicates).
  final double titleSimilarityThreshold;

  const RecommendationWeights({
    this.relatedArtist = 40.0,
    this.sameGenre = 30.0,
    this.userHistory = 20.0,
    this.randomDiscovery = 10.0,
    this.hashtagSemantic = 35.0,
    this.sameArtistBonus = 15.0,
    this.favoriteArtistBonus = 10.0,
    this.skipPenalty = 50.0,
    this.recencyDecayBase = 25.0,
    this.titleSimilarityThreshold = 0.45,
  });
}
