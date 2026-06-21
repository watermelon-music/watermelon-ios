/// A song reference inside a [Playlist]. Ported from Kotlin `Playlist.PlaylistSong`.
class PlaylistSong {
  final String songId;
  final int position;
  final String title;
  final String artist;
  final String? coverUrl;
  final String? audioUrl;

  const PlaylistSong({
    required this.songId,
    required this.position,
    this.title = '',
    this.artist = '',
    this.coverUrl,
    this.audioUrl,
  });
}

/// A user playlist. Ported from Kotlin `domain.model.Playlist`.
class Playlist {
  final String id;
  final String name;
  final String? description;
  final String? coverUrl;
  final String ownerId;
  final List<PlaylistSong> songs;
  final int createdAt;
  final int updatedAt;
  final String? shareCode;
  final bool isPublic;
  final int shareCount;
  final int saveCount;
  final int copyCount;

  const Playlist({
    required this.id,
    required this.name,
    this.description,
    this.coverUrl,
    required this.ownerId,
    this.songs = const [],
    required this.createdAt,
    required this.updatedAt,
    this.shareCode,
    this.isPublic = false,
    this.shareCount = 0,
    this.saveCount = 0,
    this.copyCount = 0,
  });

  Playlist copyWith({
    String? id,
    String? name,
    String? description,
    String? coverUrl,
    String? ownerId,
    List<PlaylistSong>? songs,
    int? createdAt,
    int? updatedAt,
    String? shareCode,
    bool? isPublic,
    int? shareCount,
    int? saveCount,
    int? copyCount,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      ownerId: ownerId ?? this.ownerId,
      songs: songs ?? this.songs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      shareCode: shareCode ?? this.shareCode,
      isPublic: isPublic ?? this.isPublic,
      shareCount: shareCount ?? this.shareCount,
      saveCount: saveCount ?? this.saveCount,
      copyCount: copyCount ?? this.copyCount,
    );
  }

  @override
  bool operator ==(Object other) => other is Playlist && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
