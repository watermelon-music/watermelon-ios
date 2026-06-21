import '../domain/models/song.dart';
import '../models/track.dart';

/// Bridges the design-era mock [Track] (asset art, [Duration]) to the domain
/// [Song] the real [PlaybackController] consumes. Mock tracks carry no real
/// `audioUrl`, so they won't resolve to audio — playing one falls through to
/// the autoplay engine (which searches the live catalog by artist name).
/// Real catalog/Audius songs already arrive as [Song] and bypass this.
extension TrackToSong on Track {
  Song toSong() => Song(
        id: id,
        title: title,
        artistId: artist.toLowerCase(),
        artistName: artist,
        durationMs: duration.inMilliseconds,
        coverUrl: art, // asset path — CoverImage renders it as an asset
      );
}

extension TrackListToSongs on List<Track> {
  List<Song> toSongs() => map((t) => t.toSong()).toList();
}
