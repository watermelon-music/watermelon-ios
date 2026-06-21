/// A playable track. Ported from Kotlin `domain.model.Song`.
class Song {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final String? albumId;
  final String? albumName;
  final int durationMs;
  final String? coverUrl;

  /// Resolved audio stream URL. May be null until extracted at play time.
  final String? audioUrl;
  final String? genre;
  final String? releaseDate;

  const Song({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    this.albumId,
    this.albumName,
    this.durationMs = 0,
    this.coverUrl,
    this.audioUrl,
    this.genre,
    this.releaseDate,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artistId,
    String? artistName,
    String? albumId,
    String? albumName,
    int? durationMs,
    String? coverUrl,
    String? audioUrl,
    String? genre,
    String? releaseDate,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      albumId: albumId ?? this.albumId,
      albumName: albumName ?? this.albumName,
      durationMs: durationMs ?? this.durationMs,
      coverUrl: coverUrl ?? this.coverUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      genre: genre ?? this.genre,
      releaseDate: releaseDate ?? this.releaseDate,
    );
  }

  @override
  bool operator ==(Object other) => other is Song && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
