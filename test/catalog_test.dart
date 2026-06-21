import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watermelon/data/local/app_database.dart' show AppDatabase;
import 'package:watermelon/data/remote/catalog_source.dart';
import 'package:watermelon/data/repositories/music_catalog_repository_impl.dart';
import 'package:watermelon/domain/models/song.dart';

Song _song(
  String id, {
  String title = 'A Song',
  String artist = 'Artist',
  int durationSec = 180,
}) =>
    Song(
      id: id,
      title: title,
      artistId: artist.toLowerCase(),
      artistName: artist,
      durationMs: durationSec * 1000,
    );

class FakeSource implements CatalogSource {
  @override
  final String name;
  final List<Song> results;
  final bool throws;
  int searchCalls = 0;

  FakeSource(this.name, {this.results = const [], this.throws = false});

  Future<List<Song>> _respond() async {
    searchCalls++;
    if (throws) throw Exception('network down');
    return results;
  }

  @override
  Future<List<Song>> search(String query) => _respond();
  @override
  Future<List<Song>> trending() => _respond();
  @override
  Future<List<Song>> byGenre(String genre) => _respond();
}

void main() {
  late AppDatabase db;
  var clock = 1000;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    clock = 1000;
  });
  tearDown(() => db.close());

  MusicCatalogRepositoryImpl repo(List<CatalogSource> sources) =>
      MusicCatalogRepositoryImpl(sources, db, now: () => clock);

  test('uses the first source that returns results (priority order)', () async {
    final primary = FakeSource('primary'); // empty
    final secondary = FakeSource('secondary', results: [_song('s1')]);
    final tertiary = FakeSource('tertiary', results: [_song('s2')]);

    final out = await repo([primary, secondary, tertiary]).search('x').toList();

    expect(out.last.map((s) => s.id), ['s1']);
    expect(secondary.searchCalls, 1);
    expect(tertiary.searchCalls, 0); // not reached
  });

  test('skips a throwing source and falls through', () async {
    final broken = FakeSource('broken', throws: true);
    final good = FakeSource('good', results: [_song('ok')]);

    final out = await repo([broken, good]).search('x').toList();
    expect(out.last.single.id, 'ok');
  });

  test('filters out non-music and off-length tracks', () async {
    final source = FakeSource('s', results: [
      _song('music', durationSec: 200),
      _song('tooShort', durationSec: 10),
      _song('tooLong', durationSec: 800),
      _song('podcast', title: 'My Podcast Ep 1', durationSec: 200),
    ]);

    final out = await repo([source]).search('x').toList();
    expect(out.last.map((s) => s.id), ['music']);
  });

  test('cache-then-network: second call emits cache first then fresh',
      () async {
    final source = FakeSource('s', results: [_song('a', durationSec: 120)]);
    final r = repo([source]);

    // First call: no cache → one emission (fresh), and it gets cached.
    final first = await r.search('q').toList();
    expect(first, [
      [isA<Song>()]
    ]);

    // Second call: cache hit → cached emission, then fresh emission.
    final second = await r.search('q').toList();
    expect(second.length, 2);
    expect(second[0].single.id, 'a'); // from cache
    expect(second[1].single.id, 'a'); // from network
  });

  test('offline fallback: serves cache when the network fails', () async {
    // Warm the cache.
    await repo([FakeSource('s', results: [_song('a', durationSec: 120)])])
        .search('q')
        .toList();

    // Now the network fails — cached result should still be served.
    final out = await repo([FakeSource('s', throws: true)]).search('q').toList();
    expect(out.first.single.id, 'a');
  });
}
