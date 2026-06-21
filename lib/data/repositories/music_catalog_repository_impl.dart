import 'package:drift/drift.dart' show Value;

import '../../config/app_constants.dart';
import '../../domain/models/song.dart';
import '../../domain/repositories/music_catalog_repository.dart';
import '../local/app_database.dart' as db;
import '../remote/catalog_source.dart';

int _wallClock() => DateTime.now().millisecondsSinceEpoch;

/// Catalog repository with source-priority, content filtering and
/// cache-then-network. Ported from Kotlin `MusicCatalogRepositoryImpl`
/// (see LOGIC_IMPLEMENTATION.md §4 "Catalog source priority" + §5 caching).
///
/// [sources] are tried in order; the first to return (post-filter) results wins.
class MusicCatalogRepositoryImpl implements MusicCatalogRepository {
  final List<CatalogSource> sources;
  final db.AppDatabase _db;
  final int Function() _now;

  MusicCatalogRepositoryImpl(
    this.sources,
    this._db, {
    this._now = _wallClock,
  });

  @override
  Stream<List<Song>> search(String query) {
    final key = query.trim().toLowerCase();
    if (key.isEmpty) return Stream.value(const []);
    return _cachedThenNetwork(key, (s) => s.search(query));
  }

  @override
  Stream<List<Song>> getTrendingMusic() =>
      _cachedThenNetwork('trending', (s) => s.trending());

  @override
  Stream<List<Song>> getSongsByGenre(String genre) {
    final key = 'genre:${genre.trim().toLowerCase()}';
    return _cachedThenNetwork(key, (s) => s.byGenre(genre));
  }

  Stream<List<Song>> _cachedThenNetwork(
    String cacheKey,
    Future<List<Song>> Function(CatalogSource) op,
  ) async* {
    final cached = await _readCache(cacheKey);
    if (cached.isNotEmpty) yield cached;

    try {
      final fresh = await _firstNonEmpty(op);
      if (fresh.isNotEmpty) {
        await _writeCache(cacheKey, fresh);
        yield fresh;
      } else if (cached.isEmpty) {
        yield const [];
      }
    } catch (_) {
      if (cached.isEmpty) yield const [];
    }
  }

  /// First source returning non-empty results after filtering.
  Future<List<Song>> _firstNonEmpty(
    Future<List<Song>> Function(CatalogSource) op,
  ) async {
    for (final source in sources) {
      try {
        final filtered = _filter(await op(source));
        if (filtered.isNotEmpty) return filtered;
      } catch (_) {
        // Try the next source.
      }
    }
    return const [];
  }

  // ── Content filter (drop non-music / off-length) ───────────────────────────

  static const _nonMusicKeywords = [
    'gaming',
    'gameplay',
    'vlog',
    'news',
    'podcast',
    'trailer',
    'interview',
    'reaction',
  ];

  List<Song> _filter(List<Song> songs) => songs.where(_isMusic).toList();

  bool _isMusic(Song s) {
    if (s.id.isEmpty) return false;
    final durSec = s.durationMs ~/ 1000;
    if (durSec != 0 &&
        (durSec < AppConstants.minMusicDurationSec ||
            durSec > AppConstants.maxMusicDurationSec)) {
      return false;
    }
    final haystack = '${s.title} ${s.artistName}'.toLowerCase();
    if (_nonMusicKeywords.any(haystack.contains)) return false;
    return true;
  }

  // ── Cache ──────────────────────────────────────────────────────────────────

  Future<List<Song>> _readCache(String key) async {
    final rows = await _db.getCachedSongs(
      key,
      AppConstants.cachedSongsTtl.inMilliseconds,
      _now(),
    );
    return rows
        .map((c) => Song(
              id: c.songId,
              title: c.title,
              artistId: '',
              artistName: c.artist,
              durationMs: c.durationMs,
              coverUrl: c.coverUrl,
              audioUrl: c.audioUrl,
              genre: c.genre,
            ))
        .toList();
  }

  Future<void> _writeCache(String key, List<Song> songs) async {
    final now = _now();
    final rows = <db.CachedSongsCompanion>[];
    final capped = songs.take(AppConstants.cachedSongsPerQuery).toList();
    for (var i = 0; i < capped.length; i++) {
      final s = capped[i];
      rows.add(db.CachedSongsCompanion.insert(
        songId: s.id,
        query: key,
        title: s.title,
        artist: s.artistName,
        coverUrl: Value(s.coverUrl),
        audioUrl: Value(s.audioUrl),
        durationMs: Value(s.durationMs),
        genre: Value(s.genre),
        position: Value(i),
        cachedAt: now,
      ));
    }
    await _db.cacheSongs(key, rows);
  }
}
