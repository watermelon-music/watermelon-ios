// Pure mappers from Supabase row JSON (snake_case) to domain models.
// Column names follow the Kotlin app's Supabase schema (see §4.9).
import '../../../domain/models/broadcast.dart';
import '../../../domain/models/playlist.dart';
import '../../../domain/models/remote_config.dart';
import '../../../domain/models/user.dart';

SubscriptionPlan planFromString(String? raw) {
  switch ((raw ?? '').toLowerCase()) {
    case 'premium_individual':
    case 'individual':
      return SubscriptionPlan.premiumIndividual;
    case 'premium_family':
    case 'family':
      return SubscriptionPlan.premiumFamily;
    case 'student':
      return SubscriptionPlan.student;
    default:
      return SubscriptionPlan.free;
  }
}

int parseTimestamp(dynamic raw) {
  if (raw == null) return 0;
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  return DateTime.tryParse(raw.toString())?.millisecondsSinceEpoch ?? 0;
}

bool _bool(dynamic raw, {bool fallback = false}) {
  if (raw is bool) return raw;
  if (raw is num) return raw != 0;
  if (raw is String) return raw.toLowerCase() == 'true' || raw == '1';
  return fallback;
}

int _int(dynamic raw, int fallback) {
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  return int.tryParse('${raw ?? ''}') ?? fallback;
}

User profileRowToUser(Map<String, dynamic> j) => User(
      id: (j['id'] ?? '').toString(),
      email: (j['email'] ?? '').toString(),
      username: j['username']?.toString(),
      displayName: j['display_name']?.toString(),
      avatarUrl: j['avatar_url']?.toString(),
      plan: planFromString(j['plan']?.toString()),
      createdAt: parseTimestamp(j['created_at']),
    );

Broadcast broadcastFromRow(Map<String, dynamic> j) => Broadcast(
      id: _int(j['id'], 0),
      message: (j['message'] ?? '').toString(),
      sender: (j['sender'] ?? '').toString(),
      active: _bool(j['active']),
      createdAt: (j['created_at'] ?? '').toString(),
    );

RemoteConfig remoteConfigFromRow(Map<String, dynamic> j) => RemoteConfig(
      maintenanceMode: _bool(j['maintenance_mode']),
      disableYouTube: _bool(j['disable_youtube']),
      disableAudius: _bool(j['disable_audius']),
      disableJamendo: _bool(j['disable_jamendo']),
      freeMaxPlaylists: _int(j['free_max_playlists'], 3),
    );

PlaylistSong playlistSongFromRow(Map<String, dynamic> j) => PlaylistSong(
      songId: (j['song_id'] ?? '').toString(),
      position: _int(j['position'], 0),
      title: (j['title'] ?? '').toString(),
      artist: (j['artist'] ?? '').toString(),
      coverUrl: j['cover_url']?.toString(),
      audioUrl: j['audio_url']?.toString(),
    );

Playlist playlistFromRow(
  Map<String, dynamic> j, {
  List<PlaylistSong> songs = const [],
}) =>
    Playlist(
      id: (j['id'] ?? '').toString(),
      name: (j['name'] ?? '').toString(),
      description: j['description']?.toString(),
      coverUrl: j['cover_url']?.toString(),
      ownerId: (j['owner_id'] ?? j['user_id'] ?? '').toString(),
      songs: songs,
      createdAt: parseTimestamp(j['created_at']),
      updatedAt: parseTimestamp(j['updated_at']),
      shareCode: j['share_code']?.toString(),
      isPublic: _bool(j['is_public']),
      shareCount: _int(j['share_count'], 0),
      saveCount: _int(j['save_count'], 0),
      copyCount: _int(j['copy_count'], 0),
    );
