import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:watermelon/domain/autoplay/autoplay_engine.dart';
import 'package:watermelon/domain/autoplay/autoplay_signals.dart';
import 'package:watermelon/domain/autoplay/recommendation_engine.dart';
import 'package:watermelon/domain/autoplay/title_similarity.dart';
import 'package:watermelon/domain/models/song.dart';
import 'package:watermelon/domain/repositories/music_catalog_repository.dart';

// ── Test doubles ─────────────────────────────────────────────────────────────

Song _song(
  String id, {
  String? title,
  String artist = 'Artist',
  String? album,
  String? genre,
}) {
  return Song(
    id: id,
    title: title ?? id,
    artistId: artist.toLowerCase(),
    artistName: artist,
    albumName: album,
    genre: genre,
  );
}

class FakeCatalog implements MusicCatalogRepository {
  final List<Song> pool;
  FakeCatalog(this.pool);

  @override
  Stream<List<Song>> getTrendingMusic() => Stream.value(pool);

  @override
  Stream<List<Song>> search(String query) {
    final q = query.toLowerCase();
    return Stream.value(
      pool
          .where((s) =>
              s.artistName.toLowerCase().contains(q) ||
              s.title.toLowerCase().contains(q))
          .toList(),
    );
  }

  @override
  Stream<List<Song>> getSongsByGenre(String genre) {
    final g = genre.toLowerCase();
    return Stream.value(
      pool.where((s) => (s.genre ?? '').toLowerCase() == g).toList(),
    );
  }
}

class FakeSignals implements AutoplaySignalSource {
  final List<Song> favs;
  final Set<String> skips;
  final List<Song> recent;
  const FakeSignals({
    this.favs = const [],
    this.skips = const {},
    this.recent = const [],
  });

  @override
  Future<List<Song>> favorites() async => favs;
  @override
  Future<Set<String>> skippedSongIds() async => skips;
  @override
  Future<List<Song>> recentPlays() async => recent;
}

class FakeAnalytics implements AutoplayAnalytics {
  int playStarts = 0, skipsRecorded = 0, transitions = 0, clears = 0;
  @override
  Future<void> recordPlayStart(Song song, String source) async => playStarts++;
  @override
  Future<void> recordSkip(Song song, String context) async => skipsRecorded++;
  @override
  Future<void> recordTransition(String from, String to) async => transitions++;
  @override
  Future<void> clearAll() async => clears++;
}

RecommendationEngine _engine(List<Song> pool, {FakeSignals? signals}) {
  return RecommendationEngine(
    FakeCatalog(pool),
    signals ?? const FakeSignals(),
    random: Random(42), // deterministic
  );
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('titleSimilarity', () {
    test('identical titles → 1.0', () {
      expect(titleSimilarity('Blinding Lights', 'Blinding Lights'), 1.0);
    });

    test('remix / edit / slowed variants are near-identical (> 0.7)', () {
      const base = 'Blinding Lights';
      expect(titleSimilarity(base, 'Blinding Lights (Remix)'), greaterThan(0.7));
      expect(
          titleSimilarity(base, 'Blinding Lights - Radio Edit'), greaterThan(0.7));
      expect(titleSimilarity(base, 'Blinding Lights (slowed + reverb)'),
          greaterThan(0.7));
    });

    test('different songs score low (< 0.45)', () {
      expect(titleSimilarity('Blinding Lights', 'Bohemian Rhapsody'),
          lessThan(0.45));
    });
  });

  group('RecommendationEngine.generateQueue', () {
    test('enforces max 2 per artist and 2 per album', () async {
      final pool = [
        for (var i = 0; i < 4; i++)
          _song('a$i', artist: 'ArtistA', album: 'AlbumA'),
        for (var i = 0; i < 4; i++)
          _song('b$i', artist: 'ArtistB', album: 'AlbumB'),
      ];
      // Current song matches nothing by artist/genre/title → candidates come
      // purely from trending (random discovery).
      final current = _song('c', title: 'Hi', artist: 'Zzz');

      final queue =
          await _engine(pool).generateQueue(currentSong: current, count: 20);

      final perArtist = <String, int>{};
      final perAlbum = <String, int>{};
      for (final s in queue) {
        perArtist[s.artistName] = (perArtist[s.artistName] ?? 0) + 1;
        perAlbum[s.albumName!] = (perAlbum[s.albumName!] ?? 0) + 1;
      }
      expect(perArtist.values, everyElement(lessThanOrEqualTo(2)));
      expect(perAlbum.values, everyElement(lessThanOrEqualTo(2)));
    });

    test('never returns excluded ids or the current song', () async {
      final pool = [for (var i = 0; i < 6; i++) _song('s$i', artist: 'A$i')];
      final current = _song('s0', title: 'Hi', artist: 'A0');

      final queue = await _engine(pool).generateQueue(
        currentSong: current,
        excludeIds: {'s1', 's2'},
        count: 20,
      );

      final ids = queue.map((s) => s.id).toSet();
      expect(ids.contains('s0'), isFalse); // current
      expect(ids.contains('s1'), isFalse); // excluded
      expect(ids.contains('s2'), isFalse); // excluded
    });

    test('drops title variants of the current song', () async {
      final pool = [
        _song('r', title: 'Blinding Lights (Remix)', artist: 'The Weeknd'),
        _song('s', title: 'Save Your Tears', artist: 'The Weeknd'),
        _song('d', title: 'Levitating', artist: 'Dua Lipa'),
      ];
      final current =
          _song('c', title: 'Blinding Lights', artist: 'The Weeknd');

      final queue =
          await _engine(pool).generateQueue(currentSong: current, count: 20);
      final ids = queue.map((s) => s.id).toSet();

      expect(ids.contains('r'), isFalse); // remix filtered out
      expect(ids.contains('s'), isTrue); // genuine other track kept
    });

    test('skipped songs are penalized below fresh candidates', () async {
      final pool = [
        _song('skip', title: 'Skipped', artist: 'ArtistA'),
        _song('fresh', title: 'Fresh', artist: 'ArtistB'),
      ];
      final current = _song('c', title: 'Hi', artist: 'Zzz');
      final engine = _engine(pool, signals: const FakeSignals(skips: {'skip'}));

      final queue = await engine.generateQueue(currentSong: current, count: 20);

      // Both may appear, but the fresh (un-skipped) one must rank first.
      expect(queue.first.id, 'fresh');
    });
  });

  group('AutoplayEngine', () {
    AutoplayEngine build({
      required bool enabled,
      List<Song>? pool,
      FakeSignals? signals,
      FakeAnalytics? analytics,
    }) {
      final p = pool ?? [for (var i = 0; i < 6; i++) _song('s$i', artist: 'A$i')];
      final sig = signals ?? const FakeSignals();
      return AutoplayEngine(
        _engine(p, signals: sig),
        sig,
        analytics ?? FakeAnalytics(),
        isEnabled: () => enabled,
      );
    }

    test('returns null when autoplay is disabled', () async {
      final next = await build(enabled: false)
          .findNextSong(_song('c', title: 'Hi', artist: 'Zzz'));
      expect(next, isNull);
    });

    test('returns a recommendation when enabled', () async {
      final next = await build(enabled: true)
          .findNextSong(_song('c', title: 'Hi', artist: 'Zzz'));
      expect(next, isNotNull);
    });

    test('excludes recently played songs', () async {
      final pool = [for (var i = 0; i < 6; i++) _song('s$i', artist: 'A$i')];
      final engine = build(
        enabled: true,
        pool: pool,
        signals: FakeSignals(recent: [_song('s1'), _song('s2')]),
      );
      final next =
          await engine.findNextSong(_song('c', title: 'Hi', artist: 'Zzz'));
      expect(next, isNotNull);
      expect(['s1', 's2'].contains(next!.id), isFalse);
    });

    test('clearAll resets analytics and cache', () async {
      final analytics = FakeAnalytics();
      final engine = build(enabled: true, analytics: analytics);
      await engine.clearAll();
      expect(analytics.clears, 1);
    });
  });
}
