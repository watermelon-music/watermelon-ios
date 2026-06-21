import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watermelon/core/result.dart';
import 'package:watermelon/data/repositories/url_extractor_repository_impl.dart';
import 'package:watermelon/domain/autoplay/autoplay_engine.dart';
import 'package:watermelon/domain/autoplay/autoplay_signals.dart';
import 'package:watermelon/domain/autoplay/recommendation_engine.dart';
import 'package:watermelon/domain/models/downloaded_song.dart';
import 'package:watermelon/domain/models/song.dart';
import 'package:watermelon/domain/models/yt_dlp_metadata.dart';
import 'package:watermelon/domain/repositories/download_repository.dart';
import 'package:watermelon/domain/repositories/music_catalog_repository.dart';
import 'package:watermelon/domain/repositories/streaming_repository.dart';
import 'package:watermelon/domain/repositories/url_extractor_repository.dart';
import 'package:watermelon/state/playback_controller.dart';

Song _song(String id, {String? audioUrl, String artist = 'Artist'}) => Song(
      id: id,
      title: id,
      artistId: artist.toLowerCase(),
      artistName: artist,
      audioUrl: audioUrl,
    );

// ── Fakes ────────────────────────────────────────────────────────────────────

/// Records the last URL played and lets tests fire playback callbacks.
class FakeStreaming implements StreamingRepository {
  final List<StreamingCallback> callbacks = [];
  String? lastUrl;
  bool playing = false;
  bool stopped = false;
  int playCount = 0;

  void fireCompleted() {
    for (final c in callbacks) {
      c.onPlaybackCompleted();
    }
  }

  void fireError(String e) {
    for (final c in callbacks) {
      c.onPlaybackError(e);
    }
  }

  @override
  void play(String url,
      {String title = '', String artist = '', String artworkUrl = ''}) {
    lastUrl = url;
    playing = true;
    playCount++;
  }

  @override
  void addListener(StreamingCallback c) => callbacks.add(c);
  @override
  void removeListener(StreamingCallback c) => callbacks.remove(c);
  @override
  void pause() => playing = false;
  @override
  void resume() => playing = true;
  @override
  void stop() {
    stopped = true;
    playing = false;
  }

  @override
  int currentPosition() => 0;
  @override
  int duration() => 0;
  @override
  bool isPlaying() => playing;
  @override
  void seekTo(int positionMs) {}
  @override
  void setVolume(double volume) {}
}

class FakeDownloads implements DownloadRepository {
  final Map<String, String> paths;
  FakeDownloads([this.paths = const {}]);
  @override
  Future<String?> getDownloadPath(String songId) async => paths[songId];
  @override
  Future<bool> isDownloaded(String songId) async => paths.containsKey(songId);
  @override
  Stream<List<DownloadedSong>> getDownloads() => Stream.value(const []);
  @override
  Future<Result<Unit>> downloadSong(Song song, String url) async =>
      const Ok(Unit.unit);
  @override
  Future<Result<Unit>> recordDownload(Song s, String p, int f) async =>
      const Ok(Unit.unit);
  @override
  Future<Result<Unit>> deleteDownload(String songId) async =>
      const Ok(Unit.unit);
  @override
  Future<Result<Unit>> cleanupMissingFiles() async => const Ok(Unit.unit);
}

class FakeExtractor implements UrlExtractorRepository {
  final String? url;
  int invalidations = 0;
  FakeExtractor([this.url]);
  @override
  Future<Result<String>> extractAudioUrl(String s) async =>
      url == null ? Err(StateError('none')) : Ok(url!);
  @override
  Future<Result<YtDlpMetadata>> extractMetadata(String s) async =>
      Err(StateError('n/a'));
  @override
  void invalidateCache(String s) => invalidations++;
}

class FakeCatalog implements MusicCatalogRepository {
  final List<Song> pool;
  FakeCatalog(this.pool);
  @override
  Stream<List<Song>> getTrendingMusic() => Stream.value(pool);
  @override
  Stream<List<Song>> search(String q) => Stream.value(pool);
  @override
  Stream<List<Song>> getSongsByGenre(String g) => Stream.value(const []);
}

class FakeSignals implements AutoplaySignalSource {
  @override
  Future<List<Song>> favorites() async => const [];
  @override
  Future<Set<String>> skippedSongIds() async => const {};
  @override
  Future<List<Song>> recentPlays() async => const [];
}

class RecordingAnalytics implements AutoplayAnalytics {
  int plays = 0, skips = 0, transitions = 0;
  @override
  Future<void> recordPlayStart(Song s, String src) async => plays++;
  @override
  Future<void> recordSkip(Song s, String c) async => skips++;
  @override
  Future<void> recordTransition(String f, String t) async => transitions++;
  @override
  Future<void> clearAll() async {}
}

AutoplayEngine _autoplay({
  List<Song> pool = const [],
  bool enabled = true,
  AutoplayAnalytics? analytics,
}) {
  final signals = FakeSignals();
  return AutoplayEngine(
    RecommendationEngine(FakeCatalog(pool), signals),
    signals,
    analytics ?? RecordingAnalytics(),
    isEnabled: () => enabled,
  );
}

void main() {
  group('UrlExtractorRepositoryImpl', () {
    Dio dioReturning(dynamic body, {required List<int> hits}) {
      final dio = Dio();
      dio.httpClientAdapter = _StubAdapter((_) {
        hits.add(1);
        return body;
      });
      return dio;
    }

    test('extracts and parses the stream url', () async {
      final hits = <int>[];
      final repo = UrlExtractorRepositoryImpl(
        dioReturning({'url': 'https://cdn/audio.mp3'}, hits: hits),
      );
      final res = await repo.extractAudioUrl('dQw4w9WgXcQ');
      expect(res.valueOrNull, 'https://cdn/audio.mp3');
    });

    test('caches within the TTL (no second network hit)', () async {
      final hits = <int>[];
      var t = 0;
      final repo = UrlExtractorRepositoryImpl(
        dioReturning({'url': 'https://cdn/a.mp3'}, hits: hits),
        now: () => t,
      );
      await repo.extractAudioUrl('dQw4w9WgXcQ');
      t = 60 * 1000; // 1 min < 10 min TTL
      await repo.extractAudioUrl('dQw4w9WgXcQ');
      expect(hits.length, 1); // served from cache
    });

    test('refetches after invalidateCache', () async {
      final hits = <int>[];
      final repo = UrlExtractorRepositoryImpl(
        dioReturning({'url': 'https://cdn/a.mp3'}, hits: hits),
      );
      await repo.extractAudioUrl('dQw4w9WgXcQ');
      repo.invalidateCache('dQw4w9WgXcQ');
      await repo.extractAudioUrl('dQw4w9WgXcQ');
      expect(hits.length, 2);
    });
  });

  group('PlaybackController', () {
    test('source resolution: download > audioUrl > extraction', () async {
      // downloaded wins
      final s1 = FakeStreaming();
      final ctl1 = PlaybackController(s1, FakeExtractor('EXTRACTED'),
          FakeDownloads({'a': '/local/a.mp3'}), _autoplay());
      await ctl1.playQueue([_song('a', audioUrl: 'http://stream')]);
      expect(s1.lastUrl, '/local/a.mp3');
      ctl1.dispose();

      // audioUrl wins when not downloaded
      final s2 = FakeStreaming();
      final ctl2 = PlaybackController(
          s2, FakeExtractor('EXTRACTED'), FakeDownloads(), _autoplay());
      await ctl2.playQueue([_song('a', audioUrl: 'http://stream')]);
      expect(s2.lastUrl, 'http://stream');
      ctl2.dispose();

      // extraction when nothing else
      final s3 = FakeStreaming();
      final ctl3 = PlaybackController(
          s3, FakeExtractor('EXTRACTED'), FakeDownloads(), _autoplay());
      await ctl3.playQueue([_song('a')]);
      expect(s3.lastUrl, 'EXTRACTED');
      ctl3.dispose();
    });

    test('next() advances through the queue and records a skip', () async {
      final s = FakeStreaming();
      final analytics = RecordingAnalytics();
      final ctl = PlaybackController(s, FakeExtractor(), FakeDownloads(),
          _autoplay(analytics: analytics));
      await ctl.playQueue([
        _song('a', audioUrl: 'a'),
        _song('b', audioUrl: 'b'),
      ]);
      await ctl.next();
      expect(ctl.state.currentSong!.id, 'b');
      expect(s.lastUrl, 'b');
      expect(analytics.skips, 1);
      expect(analytics.transitions, 1);
      ctl.dispose();
    });

    test('repeat ALL wraps to the start at the end', () async {
      final s = FakeStreaming();
      final ctl = PlaybackController(
          s, FakeExtractor(), FakeDownloads(), _autoplay());
      await ctl.playQueue([_song('a', audioUrl: 'a'), _song('b', audioUrl: 'b')],
          startIndex: 1);
      ctl.cycleRepeat(); // none -> all
      s.fireCompleted(); // completes 'b'
      await Future<void>.delayed(Duration.zero);
      expect(ctl.state.currentIndex, 0);
      ctl.dispose();
    });

    test('repeat ONE replays the same song on completion', () async {
      final s = FakeStreaming();
      final ctl = PlaybackController(
          s, FakeExtractor(), FakeDownloads(), _autoplay());
      await ctl.playQueue([_song('a', audioUrl: 'a')]);
      ctl.cycleRepeat();
      ctl.cycleRepeat(); // none -> all -> one
      final before = s.playCount;
      s.fireCompleted();
      await Future<void>.delayed(Duration.zero);
      expect(ctl.state.repeatMode, RepeatMode.one);
      expect(ctl.state.currentSong!.id, 'a');
      // resume() called rather than a fresh play()
      expect(s.playCount, before);
      ctl.dispose();
    });

    test('autoplay refills the queue at the end', () async {
      final s = FakeStreaming();
      final ctl = PlaybackController(s, FakeExtractor(), FakeDownloads(),
          _autoplay(pool: [_song('rec', audioUrl: 'rec')]));
      await ctl.playQueue([_song('a', audioUrl: 'a')]);
      s.fireCompleted();
      await Future<void>.delayed(Duration.zero);
      expect(ctl.state.currentSong!.id, 'rec');
      expect(ctl.state.queue.length, 2);
      ctl.dispose();
    });

    test('stops at the end when autoplay is disabled', () async {
      final s = FakeStreaming();
      final ctl = PlaybackController(s, FakeExtractor(), FakeDownloads(),
          _autoplay(enabled: false));
      await ctl.playQueue([_song('a', audioUrl: 'a')]);
      s.fireCompleted();
      await Future<void>.delayed(Duration.zero);
      expect(s.stopped, isTrue);
      ctl.dispose();
    });

    test('shuffle keeps the current song first; unshuffle restores order',
        () async {
      final s = FakeStreaming();
      final ctl = PlaybackController(
          s, FakeExtractor(), FakeDownloads(), _autoplay());
      final songs = [
        for (var i = 0; i < 6; i++) _song('s$i', audioUrl: 's$i')
      ];
      await ctl.playQueue(songs, startIndex: 2);
      ctl.toggleShuffle();
      expect(ctl.state.isShuffled, isTrue);
      expect(ctl.state.queue.first.id, 's2');
      expect(ctl.state.currentIndex, 0);

      ctl.toggleShuffle();
      expect(ctl.state.isShuffled, isFalse);
      expect(ctl.state.queue.map((e) => e.id).toList(),
          ['s0', 's1', 's2', 's3', 's4', 's5']);
      ctl.dispose();
    });

    test('skips a track that fails to resolve', () async {
      final s = FakeStreaming();
      // 'a' has no source (no download, no audioUrl, extractor empty) → skip to 'b'
      final ctl = PlaybackController(
          s, FakeExtractor(), FakeDownloads(), _autoplay());
      await ctl.playQueue([_song('a'), _song('b', audioUrl: 'b')]);
      expect(ctl.state.currentSong!.id, 'b');
      expect(s.lastUrl, 'b');
      ctl.dispose();
    });
  });
}

// Minimal Dio adapter returning a canned JSON body for any request.
class _StubAdapter implements HttpClientAdapter {
  final dynamic Function(RequestOptions) handler;
  _StubAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
      RequestOptions options, Stream<List<int>>? _, Future<void>? _) async {
    final body = handler(options);
    return ResponseBody.fromString(
      _encode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      },
    );
  }

  String _encode(dynamic body) =>
      body is String ? body : _jsonEncode(body);

  @override
  void close({bool force = false}) {}
}

String _jsonEncode(dynamic body) {
  // Tiny encoder for our test maps (avoids importing dart:convert name clash).
  if (body is Map) {
    final entries = body.entries
        .map((e) => '"${e.key}":"${e.value}"')
        .join(',');
    return '{$entries}';
  }
  return '$body';
}
