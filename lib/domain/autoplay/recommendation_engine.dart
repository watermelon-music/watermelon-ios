import 'dart:math';

import '../models/song.dart';
import '../repositories/music_catalog_repository.dart';
import 'autoplay_signals.dart';
import 'recommendation_weights.dart';
import 'scored_song.dart';
import 'title_similarity.dart';

/// Generates a scored, diversified queue of recommended songs.
///
/// Pure logic over a [MusicCatalogRepository] (candidate search) and an
/// [AutoplaySignalSource] (user history). Ported verbatim from Kotlin
/// `RecommendationEngineImpl` — see `LOGIC_IMPLEMENTATION.md` §6.2.
///
/// The 5 phases: fetch candidate pools → load user signals → score every
/// candidate → diversity filter (≤2 per artist/album) → shuffle within tiers.
class RecommendationEngine {
  final MusicCatalogRepository _catalog;
  final AutoplaySignalSource _signals;
  final RecommendationWeights _weights;
  final Random _random;

  /// Per-query search cache, cleared by [invalidateCache].
  final Map<String, List<Song>> _searchCache = {};

  RecommendationEngine(
    this._catalog,
    this._signals, {
    this._weights = const RecommendationWeights(),
    Random? random,
  }) : _random = random ?? Random();

  void invalidateCache() => _searchCache.clear();

  Future<List<Song>> generateQueue({
    required Song currentSong,
    Set<String> excludeIds = const {},
    int count = 20,
  }) async {
    final excludeSet = {...excludeIds, currentSong.id};
    final curTitle = currentSong.title.toLowerCase();
    final threshold = _weights.titleSimilarityThreshold;

    // ── Phase 1: candidate pools ──────────────────────────────────────────
    final artistPool = await _relatedArtist(currentSong, excludeSet, threshold);
    final genrePool = await _sameGenre(currentSong, excludeSet);
    final historyPool = await _userHistory(excludeSet);
    final randomPool = await _randomDiscovery(excludeSet);
    final hashtagPool = await _hashtag(currentSong, excludeSet, threshold);

    final artistIds = artistPool.map((s) => s.id).toSet();
    final genreIds = genrePool.map((s) => s.id).toSet();
    final historyIds = historyPool.map((s) => s.id).toSet();
    final randomIds = randomPool.map((s) => s.id).toSet();
    final hashtagIds = hashtagPool.map((s) => s.id).toSet();

    final all = <String, Song>{};
    for (final s in [
      ...artistPool,
      ...genrePool,
      ...historyPool,
      ...randomPool,
      ...hashtagPool,
    ]) {
      all[s.id] = s;
    }

    // ── Phase 2: user signals ─────────────────────────────────────────────
    final favorites = await _signals.favorites();
    final skips = await _signals.skippedSongIds();
    final recent = await _signals.recentPlays();
    final recentIndex = <String, int>{
      for (var i = 0; i < recent.length; i++) recent[i].id: i,
    };
    final favoriteArtistNames =
        favorites.map((s) => s.artistName.toLowerCase()).toSet();

    // ── Phase 3: score ────────────────────────────────────────────────────
    final scored = <ScoredSong>[];
    for (final cand in all.values) {
      if (excludeSet.contains(cand.id)) continue;
      if (titleSimilarity(curTitle, cand.title.toLowerCase()) > threshold) {
        continue; // hard filter
      }

      var score = 0.0;
      if (artistIds.contains(cand.id)) score += _weights.relatedArtist;
      if (genreIds.contains(cand.id)) score += _weights.sameGenre;
      if (historyIds.contains(cand.id)) score += _weights.userHistory;
      if (randomIds.contains(cand.id)) score += _weights.randomDiscovery;
      if (hashtagIds.contains(cand.id)) score += _weights.hashtagSemantic;

      final candArtist = cand.artistName.toLowerCase();
      if (candArtist == currentSong.artistName.toLowerCase()) {
        score += _weights.sameArtistBonus;
      }
      if (favoriteArtistNames.contains(candArtist)) {
        score += _weights.favoriteArtistBonus;
      }
      if (skips.contains(cand.id)) score -= _weights.skipPenalty;

      final ri = recentIndex[cand.id];
      if (ri != null && recent.isNotEmpty) {
        score -= (recent.length - ri) / recent.length * _weights.recencyDecayBase;
      }

      scored.add(ScoredSong(cand, score));
    }

    // ── Phase 4: diversity filter ─────────────────────────────────────────
    scored.sort((a, b) => b.score.compareTo(a.score));
    final diversified = _applyDiversity(
      scored,
      maxPerArtist: 2,
      maxPerAlbum: 2,
      targetCount: count,
    );

    // ── Phase 5: shuffle within tiers ─────────────────────────────────────
    return _shuffleWithinTiers(diversified.map((s) => s.song).toList());
  }

  // ── candidate fetchers ────────────────────────────────────────────────────

  Future<List<Song>> _search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final key = q.toLowerCase();
    final cached = _searchCache[key];
    if (cached != null) return cached;
    final result = await _catalog.search(q).first;
    _searchCache[key] = result;
    return result;
  }

  Future<List<Song>> _relatedArtist(
    Song current,
    Set<String> exclude,
    double threshold,
  ) async {
    final out = <String, Song>{};
    final curTitle = current.title.toLowerCase();

    void take(List<Song> songs, int limit) {
      var added = 0;
      for (final s in songs) {
        if (added >= limit) break;
        if (exclude.contains(s.id) || out.containsKey(s.id)) continue;
        if (titleSimilarity(curTitle, s.title.toLowerCase()) > threshold) {
          continue;
        }
        out[s.id] = s;
        added++;
      }
    }

    take(await _search(current.artistName), 15);

    final subs = _splitArtists(current.artistName);
    if (subs.length > 1) {
      for (final sub in subs) {
        take(await _search(sub), 8);
      }
    }
    return out.values.toList();
  }

  Future<List<Song>> _sameGenre(Song current, Set<String> exclude) async {
    final genre = current.genre;
    if (genre == null || genre.trim().isEmpty) return const [];
    final songs = await _catalog.getSongsByGenre(genre).first;
    return songs.where((s) => !exclude.contains(s.id)).take(15).toList();
  }

  Future<List<Song>> _userHistory(Set<String> exclude) async {
    final out = <String, Song>{};

    final favorites = await _signals.favorites();
    final favSample = (favorites.toList()..shuffle(_random)).take(10);
    for (final f in favSample) {
      if (!exclude.contains(f.id)) out[f.id] = f;
    }

    final recent = await _signals.recentPlays();
    final artists = <String>[];
    for (final s in recent) {
      final a = s.artistName;
      if (a.isNotEmpty && !artists.contains(a)) {
        artists.add(a);
        if (artists.length >= 5) break;
      }
    }
    for (final a in artists) {
      var added = 0;
      for (final s in await _search(a)) {
        if (added >= 5) break;
        if (exclude.contains(s.id) || out.containsKey(s.id)) continue;
        out[s.id] = s;
        added++;
      }
    }
    return out.values.toList();
  }

  Future<List<Song>> _randomDiscovery(Set<String> exclude) async {
    final trending = await _catalog.getTrendingMusic().first;
    return (trending.where((s) => !exclude.contains(s.id)).toList()
          ..shuffle(_random))
        .take(10)
        .toList();
  }

  Future<List<Song>> _hashtag(
    Song current,
    Set<String> exclude,
    double threshold,
  ) async {
    const stop = {'song', 'video', 'lyric', 'lyrics'};
    final words = current.title
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 3 && !stop.contains(w))
        .toList();
    if (words.isEmpty) return const [];
    words.shuffle(_random);

    final out = <String, Song>{};
    final curTitle = current.title.toLowerCase();
    for (final w in words.take(2)) {
      var added = 0;
      for (final s in await _search(w)) {
        if (added >= 10) break;
        if (exclude.contains(s.id) || out.containsKey(s.id)) continue;
        if (titleSimilarity(curTitle, s.title.toLowerCase()) > threshold) {
          continue;
        }
        out[s.id] = s;
        added++;
      }
    }
    return out.values.toList();
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  List<String> _splitArtists(String artist) {
    return artist
        .split(RegExp(r'\s*(?:,|&|feat\.|ft\.|\bx\b)\s*', caseSensitive: false))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  List<ScoredSong> _applyDiversity(
    List<ScoredSong> scored, {
    required int maxPerArtist,
    required int maxPerAlbum,
    required int targetCount,
  }) {
    final artistCounts = <String, int>{};
    final albumCounts = <String, int>{};
    final selected = <ScoredSong>[];

    for (final item in scored) {
      final artist = item.song.artistName.toLowerCase();
      final album = item.song.albumName?.toLowerCase();

      if ((artistCounts[artist] ?? 0) >= maxPerArtist) continue;
      if (album != null && (albumCounts[album] ?? 0) >= maxPerAlbum) continue;

      selected.add(item);
      artistCounts[artist] = (artistCounts[artist] ?? 0) + 1;
      if (album != null) albumCounts[album] = (albumCounts[album] ?? 0) + 1;

      if (selected.length >= targetCount) break;
    }
    return selected;
  }

  List<Song> _shuffleWithinTiers(List<Song> songs) {
    if (songs.length <= 3) return songs;
    final out = <Song>[];
    for (var i = 0; i < songs.length; i += 3) {
      final end = min(i + 3, songs.length);
      out.addAll(songs.sublist(i, end)..shuffle(_random));
    }
    return out;
  }
}
