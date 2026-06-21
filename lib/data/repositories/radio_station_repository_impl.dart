import 'package:drift/drift.dart' show Value;

import '../../domain/models/radio_station.dart';
import '../../domain/repositories/radio_station_repository.dart';
import '../local/app_database.dart' as db;

int _wallClock() => DateTime.now().millisecondsSinceEpoch;

/// Local (offline-first) implementation of [RadioStationRepository].
///
/// Favorites + recents are stored locally. Favorite sync to Supabase lands in
/// P4; recents are local-only by design (matching the Kotlin app).
class RadioStationRepositoryImpl implements RadioStationRepository {
  final db.AppDatabase _db;
  final int Function() _now;

  RadioStationRepositoryImpl(this._db, {this._now = _wallClock});

  RadioStation _toDomain(db.RadioStation r) => RadioStation(
        stationuuid: r.stationUuid,
        name: r.name,
        url: r.url,
        urlResolved: r.urlResolved,
        favicon: r.favicon,
        country: r.country,
        countrycode: r.countrycode,
        language: r.language,
        tags: r.tags,
        bitrate: r.bitrate,
        votes: r.votes,
      );

  db.RadioStationsCompanion _companion(RadioStation s, String actionType) =>
      db.RadioStationsCompanion.insert(
        stationUuid: s.stationuuid ?? '',
        actionType: actionType,
        name: Value(s.name),
        url: Value(s.url),
        urlResolved: Value(s.urlResolved),
        favicon: Value(s.favicon),
        country: Value(s.country),
        countrycode: Value(s.countrycode),
        language: Value(s.language),
        tags: Value(s.tags),
        bitrate: Value(s.bitrate),
        votes: Value(s.votes),
        createdAt: _now(),
      );

  @override
  Stream<List<RadioStation>> getFavoriteStations() =>
      _db.watchFavoriteStations().map((rows) => rows.map(_toDomain).toList());

  @override
  Stream<List<RadioStation>> getRecentStations() =>
      _db.watchRecentStations().map((rows) => rows.map(_toDomain).toList());

  @override
  Future<void> addFavorite(RadioStation station) =>
      _db.upsertStation(_companion(station, 'favorite'));

  @override
  Future<void> removeFavorite(String stationUuid) =>
      _db.removeFavoriteStation(stationUuid);

  @override
  Future<void> recordRecentlyPlayed(RadioStation station) =>
      _db.upsertStation(_companion(station, 'recent'));

  @override
  Stream<bool> isFavorite(String stationUuid) =>
      _db.watchIsStationFavorite(stationUuid);
}
