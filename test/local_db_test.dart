import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watermelon/data/local/app_database.dart' show AppDatabase;
import 'package:watermelon/data/repositories/autoplay_local.dart';
import 'package:watermelon/data/repositories/download_repository_impl.dart';
import 'package:watermelon/data/repositories/local_user_actions_repository.dart';
import 'package:watermelon/data/repositories/radio_station_repository_impl.dart';
import 'package:watermelon/domain/autoplay/recommendation_engine.dart';
import 'package:watermelon/domain/models/radio_station.dart';
import 'package:watermelon/domain/models/song.dart';
import 'package:watermelon/domain/repositories/music_catalog_repository.dart';

Song _song(String id, {String artist = 'Artist', String? genre}) => Song(
      id: id,
      title: id,
      artistId: artist.toLowerCase(),
      artistName: artist,
      genre: genre,
    );

class FakeCatalog implements MusicCatalogRepository {
  final List<Song> pool;
  FakeCatalog(this.pool);
  @override
  Stream<List<Song>> getTrendingMusic() => Stream.value(pool);
  @override
  Stream<List<Song>> search(String q) => Stream.value(pool
      .where((s) =>
          s.artistName.toLowerCase().contains(q.toLowerCase()) ||
          s.title.toLowerCase().contains(q.toLowerCase()))
      .toList());
  @override
  Stream<List<Song>> getSongsByGenre(String g) => Stream.value(
      pool.where((s) => (s.genre ?? '').toLowerCase() == g.toLowerCase()).toList());
}

void main() {
  late AppDatabase db;
  var clock = 0;
  int tick() => ++clock;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    clock = 0;
  });
  tearDown(() => db.close());

  group('LocalUserActionsRepository', () {
    test('add / remove favorites round-trips', () async {
      final repo = LocalUserActionsRepository(db, now: tick);
      await repo.addToFavorites(_song('a'));
      await repo.addToFavorites(_song('b'));
      expect((await repo.getFavorites().first).map((s) => s.id).toSet(),
          {'a', 'b'});

      await repo.removeFromFavorites('a');
      expect((await repo.getFavorites().first).map((s) => s.id), ['b']);
    });

    test('recently-played is trimmed to the cap', () async {
      final repo = LocalUserActionsRepository(db, now: tick);
      for (var i = 0; i < 55; i++) {
        await repo.recordRecentlyPlayed(_song('s$i'));
      }
      final recentRows = (await db.select(db.userActions).get())
          .where((r) => r.actionType == 'recent')
          .toList();
      expect(recentRows.length, 50); // AppConstants.recentItemsCap
    });
  });

  group('Autoplay analytics + signals', () {
    test('plays, skips and favorites surface through the signal source',
        () async {
      final analytics = DriftAutoplayAnalytics(db, now: tick);
      final signals = DriftAutoplaySignalSource(db);
      final userRepo = LocalUserActionsRepository(db, now: tick);

      await analytics.recordPlayStart(_song('p1'), 'queue');
      await analytics.recordSkip(_song('p1'), 'manual');
      await userRepo.addToFavorites(_song('fav', artist: 'Lover'));

      expect((await signals.recentPlays()).map((s) => s.id), ['p1']);
      expect(await signals.skippedSongIds(), {'p1'});
      expect((await signals.favorites()).single.artistName, 'Lover');
    });

    test('transitions increment their count', () async {
      final analytics = DriftAutoplayAnalytics(db, now: tick);
      await analytics.recordTransition('a', 'b');
      await analytics.recordTransition('a', 'b');
      final row = await (db.select(db.songTransitions)
            ..where((t) => t.fromSongId.equals('a') & t.toSongId.equals('b')))
          .getSingle();
      expect(row.count, 2);
    });

    test('clearAll wipes history, skips and transitions', () async {
      final analytics = DriftAutoplayAnalytics(db, now: tick);
      await analytics.recordPlayStart(_song('p1'), 'queue');
      await analytics.recordSkip(_song('p1'), 'manual');
      await analytics.recordTransition('a', 'b');
      await analytics.clearAll();

      expect(await db.getRecentPlays(), isEmpty);
      expect(await db.getSkippedIds(), isEmpty);
      expect(await db.select(db.songTransitions).get(), isEmpty);
    });
  });

  test('recommendation engine runs against the live DB signal source',
      () async {
    // Seed a favorite so the favorite-artist bonus is exercised end-to-end.
    await LocalUserActionsRepository(db, now: tick)
        .addToFavorites(_song('fav', artist: 'Boygenius'));

    final pool = [
      _song('x1', artist: 'Boygenius'),
      _song('x2', artist: 'Phoebe'),
      _song('x3', artist: 'Julien'),
    ];
    final engine = RecommendationEngine(
      FakeCatalog(pool),
      DriftAutoplaySignalSource(db),
      random: Random(1),
    );

    final queue = await engine.generateQueue(
      currentSong: _song('cur', artist: 'Seed'),
      count: 20,
    );
    expect(queue, isNotEmpty);
  });

  group('DownloadRepositoryImpl', () {
    test('record / query / delete download metadata', () async {
      final repo = DownloadRepositoryImpl(db, now: tick);
      await repo.recordDownload(_song('d1'), '/music/d1.mp3', 1234);

      expect(await repo.isDownloaded('d1'), isTrue);
      expect(await repo.getDownloadPath('d1'), '/music/d1.mp3');
      expect((await repo.getDownloads().first).single.songId, 'd1');

      await repo.deleteDownload('d1');
      expect(await repo.isDownloaded('d1'), isFalse);
    });

    test('downloadSong reports unimplemented until P2', () async {
      final res =
          await DownloadRepositoryImpl(db).downloadSong(_song('d1'), 'http://x');
      expect(res.isErr, isTrue);
    });
  });

  group('RadioStationRepositoryImpl', () {
    test('favorites add / remove + isFavorite stream', () async {
      final repo = RadioStationRepositoryImpl(db, now: tick);
      const station = RadioStation(stationuuid: 'uuid-1', name: 'Jazz FM');

      await repo.addFavorite(station);
      expect((await repo.getFavoriteStations().first).single.name, 'Jazz FM');
      expect(await repo.isFavorite('uuid-1').first, isTrue);

      await repo.removeFavorite('uuid-1');
      expect(await repo.getFavoriteStations().first, isEmpty);
      expect(await repo.isFavorite('uuid-1').first, isFalse);
    });
  });
}
