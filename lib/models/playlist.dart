import 'track.dart';

/// A playlist with a hero cover, owner/meta, and an ordered track list.
class Playlist {
  final String id;
  final String title;
  final String description;
  final String cover;
  final String owner;
  final String ownerAvatar;
  final int saves;
  final String totalDuration; // e.g. "2h 14m"
  final List<Track> tracks;

  const Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.cover,
    required this.owner,
    required this.ownerAvatar,
    required this.saves,
    required this.totalDuration,
    required this.tracks,
  });
}

/// A square-art playlist/album reference (Home grids, Profile grid).
class PlaylistRef {
  final String title;
  final String art;
  final String subtitle; // e.g. "24 songs" or artist name

  const PlaylistRef({
    required this.title,
    required this.art,
    this.subtitle = '',
  });
}
