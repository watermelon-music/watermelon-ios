import 'song.dart';

/// An album. Ported from Kotlin `domain.model.Album`.
class Album {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final String? coverUrl;
  final String? releaseDate;
  final String? genre;
  final List<Song> songs;

  const Album({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    this.coverUrl,
    this.releaseDate,
    this.genre,
    this.songs = const [],
  });

  @override
  bool operator ==(Object other) => other is Album && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
