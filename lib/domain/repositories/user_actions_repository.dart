import '../../core/result.dart';
import '../models/song.dart';

/// User-specific actions backed by Supabase (favorites + recently played).
/// Ported from Kotlin `domain.repository.UserActionsRepository`.
abstract class UserActionsRepository {
  Stream<List<Song>> getRecentlyPlayed();
  Stream<List<Song>> getFavorites();
  Future<Result<Unit>> addToFavorites(Song song);
  Future<Result<Unit>> removeFromFavorites(String songId);
  Future<Result<Unit>> recordRecentlyPlayed(Song song);
}
