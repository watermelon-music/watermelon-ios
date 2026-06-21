/// Title-similarity primitives used by the recommendation engine to filter out
/// near-duplicate tracks (remixes, edits, slowed+reverb versions, …).
///
/// Ported verbatim from Kotlin `RecommendationEngineImpl` (see
/// `LOGIC_IMPLEMENTATION.md` §6.3). Similarity = `1 - levenshtein/maxLen` over
/// normalized titles; the engine drops candidates scoring `> 0.45`.
library;

import 'dart:math';

final RegExp _bracketsRegex = RegExp(r'\(.*?\)|\[.*?\]');
final RegExp _variantRegex = RegExp(
  r'\b(remix|edit|extended|radio|mix|cover|live|acoustic|slowed|reverb|'
  r'phonk|instrumental|karaoke|version|vip|bootleg|flip)\b',
);
final RegExp _nonAlphaNumRegex = RegExp(r'[^a-z0-9]');

/// Strip brackets, variant keywords, and non-alphanumerics; lowercase.
String normalizeTitle(String title) {
  return title
      .toLowerCase()
      .replaceAll(_bracketsRegex, '')
      .replaceAll(_variantRegex, '')
      .replaceAll(_nonAlphaNumRegex, '')
      .trim();
}

/// Standard Levenshtein edit distance (insert/delete/substitute cost 1).
int levenshteinDistance(String s1, String s2) {
  final len1 = s1.length;
  final len2 = s2.length;
  if (len1 == 0) return len2;
  if (len2 == 0) return len1;

  var prev = List<int>.generate(len2 + 1, (j) => j);
  var curr = List<int>.filled(len2 + 1, 0);

  for (var i = 1; i <= len1; i++) {
    curr[0] = i;
    for (var j = 1; j <= len2; j++) {
      final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
      curr[j] = [
        curr[j - 1] + 1, // insertion
        prev[j] + 1, // deletion
        prev[j - 1] + cost, // substitution
      ].reduce(min);
    }
    final tmp = prev;
    prev = curr;
    curr = tmp;
  }
  return prev[len2];
}

/// Similarity in [0.0, 1.0]: `1.0` = identical after normalization, `0.0` =
/// disjoint (or one side empty).
double titleSimilarity(String a, String b) {
  final na = normalizeTitle(a);
  final nb = normalizeTitle(b);
  if (na == nb) return 1.0;
  if (na.isEmpty || nb.isEmpty) return 0.0;
  final dist = levenshteinDistance(na, nb);
  final maxLen = max(na.length, nb.length);
  return 1.0 - dist / maxLen;
}
