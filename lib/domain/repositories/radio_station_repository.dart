import '../models/radio_station.dart';

/// Radio favorites + recents. Ported from Kotlin
/// `domain.repository.RadioStationRepository`.
abstract class RadioStationRepository {
  Stream<List<RadioStation>> getFavoriteStations();
  Stream<List<RadioStation>> getRecentStations();
  Future<void> addFavorite(RadioStation station);
  Future<void> removeFavorite(String stationUuid);
  Future<void> recordRecentlyPlayed(RadioStation station);
  Stream<bool> isFavorite(String stationUuid);
}
