import 'package:just_audio/just_audio.dart';

import '../../core/app_logger.dart';
import '../../domain/repositories/streaming_repository.dart';

/// [StreamingRepository] backed by `just_audio`.
///
/// Wraps a single [AudioPlayer], translating its reactive streams into the
/// callback contract the rest of the app expects (Kotlin parity). Background /
/// lockscreen controls (audio_service) are an additive follow-up.
class StreamingRepositoryImpl implements StreamingRepository {
  final AudioPlayer _player;
  final List<StreamingCallback> _callbacks = [];

  StreamingRepositoryImpl([AudioPlayer? player])
      : _player = player ?? AudioPlayer() {
    _wireStreams();
  }

  void _wireStreams() {
    _player.playerStateStream.listen((s) {
      for (final c in _callbacks) {
        c.onIsPlayingChanged(s.playing);
        c.onPlaybackStateChanged(
          s.processingState == ProcessingState.buffering ||
              s.processingState == ProcessingState.loading,
        );
        if (s.processingState == ProcessingState.completed) {
          c.onPlaybackCompleted();
        }
      }
    });
    _player.durationStream.listen((d) {
      if (d == null) return;
      for (final c in _callbacks) {
        c.onDurationChanged(d.inMilliseconds);
      }
    });
    _player.playbackEventStream.listen(
      (_) {},
      onError: (Object e, _) {
        for (final c in _callbacks) {
          c.onPlaybackError(e.toString());
        }
      },
    );
  }

  @override
  void play(String url,
      {String title = '', String artist = '', String artworkUrl = ''}) {
    final source = _normalize(url);
    AppLog.boot('streaming.play', {'scheme': source.scheme, 'host': source.host});
    // Local files (downloaded / YouTube cache) and clean CDN URLs (Audius/Jamendo)
    // both play via a plain URI source.
    _player
        .setAudioSource(AudioSource.uri(source))
        .then((_) => _player.play())
        .catchError((Object e) {
      AppLog.error('boot', 'streaming.play failed', error: e);
      for (final c in _callbacks) {
        c.onPlaybackError(e.toString());
      }
    });
  }

  Uri _normalize(String url) {
    if (url.startsWith('http') || url.startsWith('file://')) {
      return Uri.parse(url);
    }
    // Treat bare paths as local files.
    return Uri.file(url);
  }

  @override
  void pause() => _player.pause();

  @override
  void resume() => _player.play();

  @override
  void stop() => _player.stop();

  @override
  void seekTo(int positionMs) =>
      _player.seek(Duration(milliseconds: positionMs));

  @override
  void setVolume(double volume) => _player.setVolume(volume);

  @override
  bool isPlaying() => _player.playing;

  @override
  int currentPosition() => _player.position.inMilliseconds;

  @override
  int duration() => _player.duration?.inMilliseconds ?? 0;

  @override
  void addListener(StreamingCallback callback) => _callbacks.add(callback);

  @override
  void removeListener(StreamingCallback callback) =>
      _callbacks.remove(callback);

  void dispose() => _player.dispose();
}
