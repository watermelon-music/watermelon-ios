/// An artist. Ported from Kotlin `domain.model.Artist`.
class Artist {
  final String id;
  final String name;
  final String? bio;
  final String? imageUrl;
  final List<String> genres;

  const Artist({
    required this.id,
    required this.name,
    this.bio,
    this.imageUrl,
    this.genres = const [],
  });

  @override
  bool operator ==(Object other) => other is Artist && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
