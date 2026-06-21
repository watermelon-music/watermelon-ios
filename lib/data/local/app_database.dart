import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../config/app_constants.dart';

part 'app_database.g.dart';

// ── Tables (ported from the Kotlin Room entities; see LOGIC_IMPLEMENTATION.md §5) ──

/// Play records — most-recent-first feed and an autoplay recency signal.
class PlayHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get songId => text()();
  TextColumn get songTitle => text()();
  TextColumn get songArtist => text()();
  TextColumn get songCoverUrl => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('unknown'))();
  IntColumn get playedAt => integer()();
}

/// Skipped songs — an autoplay negative signal.
class Skips extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get songId => text()();
  TextColumn get songTitle => text()();
  TextColumn get songArtist => text()();
  IntColumn get skippedAt => integer()();
  TextColumn get context => text().nullable()();
}

/// Song→song transitions with frequency count.
class SongTransitions extends Table {
  TextColumn get fromSongId => text()();
  TextColumn get toSongId => text()();
  IntColumn get count => integer().withDefault(const Constant(1))();
  IntColumn get lastTransitionAt => integer()();

  @override
  Set<Column> get primaryKey => {fromSongId, toSongId};
}

/// Per-song recommendation scores (reserved for future scoring persistence).
class SongScores extends Table {
  TextColumn get songId => text()();
  RealColumn get score => real().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {songId};
}

/// Favorites + recently-played songs (distinguished by [actionType]).
class UserActions extends Table {
  TextColumn get songId => text()();

  /// 'favorite' or 'recent'.
  TextColumn get actionType => text()();
  TextColumn get songTitle => text()();
  TextColumn get songArtist => text()();
  TextColumn get songCoverUrl => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  TextColumn get albumName => text().nullable()();
  TextColumn get genre => text().nullable()();
  IntColumn get createdAt => integer()();
  BoolColumn get syncedToServer =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {songId, actionType}
      ];
}

/// Radio favorites + recents (distinguished by [actionType]).
class RadioStations extends Table {
  TextColumn get stationUuid => text()();

  /// 'favorite' or 'recent'.
  TextColumn get actionType => text()();
  TextColumn get name => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get urlResolved => text().nullable()();
  TextColumn get favicon => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get countrycode => text().nullable()();
  TextColumn get language => text().nullable()();
  TextColumn get tags => text().nullable()();
  IntColumn get bitrate => integer().withDefault(const Constant(0))();
  IntColumn get votes => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  BoolColumn get syncedToServer =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {stationUuid, actionType}
      ];
}

/// Offline downloads (local only — never synced).
class DownloadedSongs extends Table {
  TextColumn get songId => text()();
  TextColumn get title => text()();
  TextColumn get artist => text()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get localFilePath => text()();
  IntColumn get fileSize => integer().withDefault(const Constant(0))();
  IntColumn get downloadedAt => integer()();

  @override
  Set<Column> get primaryKey => {songId};
}

/// Search/trending results cache (TTL-bounded).
class CachedSongs extends Table {
  TextColumn get songId => text()();

  /// Lowercased search query, or 'trending'.
  TextColumn get query => text()();
  TextColumn get title => text()();
  TextColumn get artist => text()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();
  TextColumn get genre => text().nullable()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  IntColumn get cachedAt => integer()();

  @override
  Set<Column> get primaryKey => {songId, query};
}

/// Offline copies of playlists.
class CachedPlaylists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get ownerId => text()();
  TextColumn get shareCode => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Songs belonging to a cached playlist.
class CachedPlaylistSongs extends Table {
  TextColumn get playlistId => text()();
  TextColumn get songId => text()();
  IntColumn get position => integer()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get artist => text().withDefault(const Constant(''))();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get audioUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {playlistId, songId};
}

// ── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  PlayHistory,
  Skips,
  SongTransitions,
  SongScores,
  UserActions,
  RadioStations,
  DownloadedSongs,
  CachedSongs,
  CachedPlaylists,
  CachedPlaylistSongs,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'watermelon'));

  /// In-memory / custom executor — used by tests.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  // ── Play history ───────────────────────────────────────────────────────────

  /// Most-recent-first, capped at [AppConstants.historyCap].
  Future<List<PlayHistoryData>> getRecentPlays() {
    return (select(playHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.playedAt)])
          ..limit(AppConstants.historyCap))
        .get();
  }

  Stream<List<PlayHistoryData>> watchRecentPlays() {
    return (select(playHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.playedAt)])
          ..limit(AppConstants.historyCap))
        .watch();
  }

  Future<void> insertPlay(PlayHistoryCompanion entry) async {
    await into(playHistory).insert(entry);
    await _trim(playHistory, playHistory.id, playHistory.playedAt,
        AppConstants.historyCap);
  }

  Future<void> clearPlayHistory() => delete(playHistory).go();

  // ── Skips ────────────────────────────────────────────────────────────────────

  Future<Set<String>> getSkippedIds() async {
    final rows = await select(skips).get();
    return rows.map((r) => r.songId).toSet();
  }

  Future<void> insertSkip(SkipsCompanion entry) async {
    await into(skips).insert(entry);
    await _trim(skips, skips.id, skips.skippedAt, AppConstants.skipsCap);
  }

  Future<void> clearSkips() => delete(skips).go();

  // ── Transitions ──────────────────────────────────────────────────────────────

  Future<void> recordTransition(String fromId, String toId, int at) async {
    final existing = await (select(songTransitions)
          ..where((t) => t.fromSongId.equals(fromId) & t.toSongId.equals(toId)))
        .getSingleOrNull();
    if (existing != null) {
      await (update(songTransitions)
            ..where(
                (t) => t.fromSongId.equals(fromId) & t.toSongId.equals(toId)))
          .write(SongTransitionsCompanion(
        count: Value(existing.count + 1),
        lastTransitionAt: Value(at),
      ));
    } else {
      await into(songTransitions).insert(SongTransitionsCompanion.insert(
        fromSongId: fromId,
        toSongId: toId,
        lastTransitionAt: at,
      ));
    }
  }

  Future<void> clearTransitions() => delete(songTransitions).go();

  // ── User actions (favorites / recent) ───────────────────────────────────────

  Stream<List<UserAction>> watchFavorites() {
    return (select(userActions)
          ..where((t) => t.actionType.equals('favorite'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<UserAction>> getFavorites() {
    return (select(userActions)
          ..where((t) => t.actionType.equals('favorite'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Stream<List<UserAction>> watchRecentlyPlayed() {
    return (select(userActions)
          ..where((t) => t.actionType.equals('recent'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(AppConstants.recentItemsCap))
        .watch();
  }

  Future<void> upsertUserAction(UserActionsCompanion entry) {
    return into(userActions).insert(
      entry,
      onConflict: DoUpdate(
        (_) => entry,
        target: [userActions.songId, userActions.actionType],
      ),
    );
  }

  Future<void> removeFavorite(String songId) {
    return (delete(userActions)
          ..where(
              (t) => t.songId.equals(songId) & t.actionType.equals('favorite')))
        .go();
  }

  Stream<bool> watchIsFavorite(String songId) {
    final q = selectOnly(userActions)
      ..addColumns([userActions.songId])
      ..where(
          userActions.songId.equals(songId) &
              userActions.actionType.equals('favorite'));
    return q.watch().map((rows) => rows.isNotEmpty);
  }

  /// Trim 'recent' rows to the cap (called after recording a play).
  Future<void> trimRecentActions() async {
    final keep = await (select(userActions)
          ..where((t) => t.actionType.equals('recent'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(AppConstants.recentItemsCap))
        .get();
    final keepIds = keep.map((r) => r.songId).toSet();
    final all = await (select(userActions)
          ..where((t) => t.actionType.equals('recent')))
        .get();
    for (final r in all) {
      if (!keepIds.contains(r.songId)) {
        await (delete(userActions)
              ..where((t) =>
                  t.songId.equals(r.songId) & t.actionType.equals('recent')))
            .go();
      }
    }
  }

  // ── Radio stations ───────────────────────────────────────────────────────────

  Stream<List<RadioStation>> watchFavoriteStations() {
    return (select(radioStations)
          ..where((t) => t.actionType.equals('favorite'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<RadioStation>> watchRecentStations() {
    return (select(radioStations)
          ..where((t) => t.actionType.equals('recent'))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(AppConstants.recentItemsCap))
        .watch();
  }

  Future<void> upsertStation(RadioStationsCompanion entry) {
    return into(radioStations).insert(
      entry,
      onConflict: DoUpdate(
        (_) => entry,
        target: [radioStations.stationUuid, radioStations.actionType],
      ),
    );
  }

  Future<void> removeFavoriteStation(String uuid) {
    return (delete(radioStations)
          ..where((t) =>
              t.stationUuid.equals(uuid) & t.actionType.equals('favorite')))
        .go();
  }

  Stream<bool> watchIsStationFavorite(String uuid) {
    final q = selectOnly(radioStations)
      ..addColumns([radioStations.stationUuid])
      ..where(radioStations.stationUuid.equals(uuid) &
          radioStations.actionType.equals('favorite'));
    return q.watch().map((rows) => rows.isNotEmpty);
  }

  // ── Downloads ────────────────────────────────────────────────────────────────

  Stream<List<DownloadedSong>> watchDownloads() {
    return (select(downloadedSongs)
          ..orderBy([(t) => OrderingTerm.desc(t.downloadedAt)]))
        .watch();
  }

  Future<void> upsertDownload(DownloadedSongsCompanion entry) {
    return into(downloadedSongs)
        .insert(entry, onConflict: DoUpdate((_) => entry));
  }

  Future<void> deleteDownload(String songId) {
    return (delete(downloadedSongs)..where((t) => t.songId.equals(songId)))
        .go();
  }

  Future<DownloadedSong?> getDownload(String songId) {
    return (select(downloadedSongs)..where((t) => t.songId.equals(songId)))
        .getSingleOrNull();
  }

  Future<List<DownloadedSong>> getAllDownloads() => select(downloadedSongs).get();

  // ── Catalog cache (search / trending / genre) ───────────────────────────────

  /// Non-expired cached rows for [query] (lowercased key), newest cache wins.
  Future<List<CachedSong>> getCachedSongs(String query, int ttlMs, int now) {
    final cutoff = now - ttlMs;
    return (select(cachedSongs)
          ..where((t) =>
              t.query.equals(query) & t.cachedAt.isBiggerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm.asc(t.position)])
          ..limit(AppConstants.cachedSongsPerQuery))
        .get();
  }

  /// Replace the cache for [query] with [rows].
  Future<void> cacheSongs(String query, List<CachedSongsCompanion> rows) async {
    await transaction(() async {
      await (delete(cachedSongs)..where((t) => t.query.equals(query))).go();
      await batch((b) => b.insertAll(cachedSongs, rows));
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Keep only the newest [cap] rows of [table] (ordered by [orderCol]).
  Future<void> _trim<T extends Table, D>(
    TableInfo<T, D> table,
    GeneratedColumn<int> idCol,
    GeneratedColumn<int> orderCol,
    int cap,
  ) async {
    final count = await (selectOnly(table)..addColumns([idCol.count()]))
        .map((r) => r.read(idCol.count()) ?? 0)
        .getSingle();
    if (count <= cap) return;
    // Delete everything older than the cap-th most-recent row.
    final survivors = await (selectOnly(table)
          ..addColumns([idCol])
          ..orderBy([OrderingTerm.desc(orderCol)])
          ..limit(cap))
        .map((r) => r.read(idCol))
        .get();
    final keep = survivors.whereType<int>().toList();
    await (delete(table)..where((_) => idCol.isNotIn(keep))).go();
  }
}
