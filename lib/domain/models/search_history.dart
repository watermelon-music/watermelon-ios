/// A past search query. Ported from Kotlin `domain.model.SearchHistory`.
class SearchHistory {
  final String query;
  final int searchedAt;

  const SearchHistory({required this.query, required this.searchedAt});
}
