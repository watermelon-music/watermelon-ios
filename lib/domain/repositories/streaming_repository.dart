/// Low-level playback abstraction over the audio engine.
///
/// Ported from Kotlin `domain.repository.StreamingRepository`. In the Flutter
/// implementation this is backed by `just_audio`; prefer exposing the player's
/// reactive streams (position/state/duration) rather than the callback
/// interface below, which is kept for parity with the original contract.
abstract class StreamingRepository {
  void play(
    String url, {
    String title,
    String artist,
    String artworkUrl,
  });
  void pause();
  void resume();
  void stop();
  void seekTo(int positionMs);
  void setVolume(double volume);
  bool isPlaying();
  int currentPosition();
  int duration();
  void addListener(StreamingCallback callback);
  void removeListener(StreamingCallback callback);
}

/// Playback event sink. Ported from Kotlin `StreamingRepository.Callback`.
abstract class StreamingCallback {
  void onPlaybackStateChanged(bool isBuffering);
  void onIsPlayingChanged(bool isPlaying);
  void onPositionDiscontinuity();
  void onDurationChanged(int durationMs);
  void onPlaybackError(String error);
  void onPlaybackCompleted();
}
