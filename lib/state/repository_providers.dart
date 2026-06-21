/// Dependency-injection seams for the domain layer (replaces Hilt).
///
/// Implemented providers are wired to their `*Impl`; not-yet-built ones throw
/// [UnimplementedError] until their migration phase lands (see
/// `LOGIC_IMPLEMENTATION.md` §13). Nothing in the UI reads the throwing ones yet
/// (screens still use `lib/data/mock_data.dart`).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../config/app_config.dart';
import '../data/local/app_database.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/remote/audius/audius_source.dart';
import '../data/remote/catalog_source.dart';
import '../data/remote/jamendo/jamendo_source.dart';
import '../data/remote/watermelon/watermelon_source.dart';
import '../data/remote/youtube/youtube_source.dart';
import '../data/remote/youtube/youtube_url_extractor.dart';
import '../data/repositories/autoplay_local.dart';
import '../data/repositories/download_repository_impl.dart';
import '../data/repositories/local_user_actions_repository.dart';
import '../data/repositories/music_catalog_repository_impl.dart';
import '../data/repositories/radio_station_repository_impl.dart';
import '../data/repositories/streaming_repository_impl.dart';
import 'playback_controller.dart';
import '../domain/autoplay/autoplay_engine.dart';
import '../domain/autoplay/autoplay_signals.dart';
import '../domain/autoplay/recommendation_engine.dart';
import '../domain/models/song.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/download_repository.dart';
import '../domain/repositories/lyrics_repository.dart';
import '../domain/repositories/music_catalog_repository.dart';
import '../domain/repositories/music_repository.dart';
import '../domain/repositories/playlist_repository.dart';
import '../domain/repositories/radio_station_repository.dart';
import '../domain/repositories/streaming_repository.dart';
import '../domain/repositories/url_extractor_repository.dart';
import '../domain/repositories/user_actions_repository.dart';

Never _unimplemented(String name) => throw UnimplementedError(
      '$name has no implementation yet — wire it when the relevant migration '
      'phase lands (see LOGIC_IMPLEMENTATION.md §13).',
    );

// ── Local database (P3) ──────────────────────────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ── Implemented repositories (P3 — local/offline-first) ──────────────────────

final userActionsRepositoryProvider = Provider<UserActionsRepository>(
  (ref) => LocalUserActionsRepository(ref.watch(appDatabaseProvider)),
);

final downloadRepositoryProvider = Provider<DownloadRepository>(
  (ref) => DownloadRepositoryImpl(ref.watch(appDatabaseProvider)),
);

final radioStationRepositoryProvider = Provider<RadioStationRepository>(
  (ref) => RadioStationRepositoryImpl(ref.watch(appDatabaseProvider)),
);

// ── YouTube (on-device extraction — yt-dlp equivalent) ───────────────────────

/// Shared [YoutubeExplode] client (search + stream extraction + downloads).
final youtubeExplodeProvider = Provider<YoutubeExplode>((ref) {
  final yt = YoutubeExplode();
  ref.onDispose(yt.close);
  return yt;
});

final youtubeSourceProvider = Provider<CatalogSource>(
  (ref) => YoutubeSource(ref.watch(youtubeExplodeProvider)),
);

// ── Catalog sources + repository (P1) ────────────────────────────────────────

final watermelonSourceProvider = Provider<CatalogSource>(
  (ref) => WatermelonSource(createDio(AppConfig.watermelonApiUrl)),
);

final jamendoSourceProvider = Provider<CatalogSource>(
  (ref) => JamendoSource(
    createDio(AppConfig.jamendoBaseUrl),
    clientId: AppConfig.jamendoClientId,
  ),
);

final audiusSourceProvider = Provider<CatalogSource>(
  (ref) => AudiusSource(createDio(AppConfig.audiusHost)),
);

// ── Autoplay engine (P5 logic wired to P3 storage) ───────────────────────────

/// Whether smart autoplay is enabled. Defaults on; persistence with Settings.
class AutoplayEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void set(bool value) => state = value;
  void toggle() => state = !state;
}

final autoplayEnabledProvider =
    NotifierProvider<AutoplayEnabledNotifier, bool>(AutoplayEnabledNotifier.new);

final autoplaySignalSourceProvider = Provider<AutoplaySignalSource>(
  (ref) => DriftAutoplaySignalSource(ref.watch(appDatabaseProvider)),
);

final autoplayAnalyticsProvider = Provider<AutoplayAnalytics>(
  (ref) => DriftAutoplayAnalytics(ref.watch(appDatabaseProvider)),
);

/// Needs [musicCatalogRepositoryProvider] (P1) for candidate search — reading
/// this before P1 lands will surface the catalog's UnimplementedError.
final recommendationEngineProvider = Provider<RecommendationEngine>(
  (ref) => RecommendationEngine(
    ref.watch(musicCatalogRepositoryProvider),
    ref.watch(autoplaySignalSourceProvider),
  ),
);

final autoplayEngineProvider = Provider<AutoplayEngine>(
  (ref) => AutoplayEngine(
    ref.watch(recommendationEngineProvider),
    ref.watch(autoplaySignalSourceProvider),
    ref.watch(autoplayAnalyticsProvider),
    isEnabled: () => ref.read(autoplayEnabledProvider),
  ),
);

// ── Pending repositories (wired in later phases) ─────────────────────────────

// ── Auth + cloud (P4 — Supabase) ─────────────────────────────────────────────

/// The Supabase client. Requires `initSupabase()` to have run in `main`.
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(supabaseClientProvider)),
);

/// Current user, reactive to auth state changes (null when signed out).
final currentUserProvider = StreamProvider(
  (ref) => ref.watch(authRepositoryProvider).getCurrentUser(),
);

/// Best human-facing name for the signed-in user, with graceful fallbacks:
/// display_name → username → email local-part → 'there'. Reactive to
/// [currentUserProvider]. Used by the home greeting and profile header.
final userDisplayNameProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider).asData?.value;
  if (user == null) return 'there';
  final displayName = user.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) return displayName;
  final username = user.username?.trim();
  if (username != null && username.isNotEmpty) return username;
  final email = user.email.trim();
  if (email.contains('@')) return email.split('@').first;
  return 'there';
});

/// Just the first name (first whitespace-separated token of the display name),
/// e.g. "Jayash Bhandary" → "Jayash". Used for greetings.
final userFirstNameProvider = Provider<String>((ref) {
  final name = ref.watch(userDisplayNameProvider).trim();
  if (name.isEmpty) return 'there';
  return name.split(RegExp(r'\s+')).first;
});

/// `@handle` for the signed-in user (username → email local-part). Empty when
/// signed out / unknown.
final userHandleProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider).asData?.value;
  if (user == null) return '';
  final username = user.username?.trim();
  if (username != null && username.isNotEmpty) return '@$username';
  final email = user.email.trim();
  if (email.contains('@')) return '@${email.split('@').first}';
  return '';
});

/// Whether a session is active.
final isAuthenticatedProvider = StreamProvider(
  (ref) => ref.watch(authRepositoryProvider).isAuthenticated(),
);

final musicRepositoryProvider = Provider<MusicRepository>(
  (ref) => _unimplemented('MusicRepository'), // P1
);

/// Sources tried in priority order: **YouTube (on-device extraction)** first —
/// search/trending/genre all come from YouTube — then Audius and Jamendo as
/// free-catalog fallbacks. (The Watermelon yt-dlp backend is bypassed: it 404s
/// the stream paths and its server-side yt-dlp is broken on the free tier.)
final musicCatalogRepositoryProvider = Provider<MusicCatalogRepository>(
  (ref) => MusicCatalogRepositoryImpl(
    [
      ref.watch(youtubeSourceProvider),
      ref.watch(audiusSourceProvider),
      ref.watch(jamendoSourceProvider),
    ],
    ref.watch(appDatabaseProvider),
  ),
);

final playlistRepositoryProvider = Provider<PlaylistRepository>(
  (ref) => _unimplemented('PlaylistRepository'), // P4
);

// ── Playback (P2) ────────────────────────────────────────────────────────────

final streamingRepositoryProvider = Provider<StreamingRepository>((ref) {
  final repo = StreamingRepositoryImpl();
  ref.onDispose(repo.dispose);
  return repo;
});

/// On-device YouTube audio extraction (replaces the broken backend yt-dlp).
final urlExtractorRepositoryProvider = Provider<UrlExtractorRepository>(
  (ref) => YoutubeUrlExtractor(ref.watch(youtubeExplodeProvider)),
);

/// The app-wide player. Drives queue, repeat/shuffle, source resolution,
/// autoplay refill, and analytics. It's a [ChangeNotifier] — listen in the UI
/// with `ListenableBuilder(listenable: controller, ...)`.
final playbackControllerProvider = Provider<PlaybackController>((ref) {
  final controller = PlaybackController(
    ref.watch(streamingRepositoryProvider),
    ref.watch(urlExtractorRepositoryProvider),
    ref.watch(downloadRepositoryProvider),
    ref.watch(autoplayEngineProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});

/// Reactive mirror of [PlaybackController.state] for the UI to `ref.watch`.
/// (The controller is a [ChangeNotifier]; this bridges it into Riverpod so
/// `select` and rebuilds work idiomatically.)
class PlaybackStateNotifier extends Notifier<PlaybackState> {
  @override
  PlaybackState build() {
    final controller = ref.watch(playbackControllerProvider);
    void listener() => state = controller.state;
    controller.addListener(listener);
    ref.onDispose(() => controller.removeListener(listener));
    return controller.state;
  }
}

final playbackStateProvider =
    NotifierProvider<PlaybackStateNotifier, PlaybackState>(
        PlaybackStateNotifier.new);

/// Live trending songs from the catalog (Watermelon → Jamendo → Audius), used
/// to feed the Home "New releases" row with real, playable tracks. Takes the
/// first non-empty emission of the cache-then-network stream.
final trendingSongsProvider = FutureProvider<List<Song>>((ref) async {
  final repo = ref.watch(musicCatalogRepositoryProvider);
  await for (final songs in repo.getTrendingMusic()) {
    if (songs.isNotEmpty) return songs;
  }
  return const [];
});

/// Live search results for [query] (YouTube first, then Audius/Jamendo). Returns
/// the first non-empty emission of the cache-then-network stream; empty for a
/// blank query.
final searchResultsProvider =
    FutureProvider.family<List<Song>, String>((ref, query) async {
  final q = query.trim();
  if (q.isEmpty) return const [];
  await for (final songs in ref.watch(musicCatalogRepositoryProvider).search(q)) {
    if (songs.isNotEmpty) return songs;
  }
  return const [];
});

// ── Pending repositories (wired in later phases) ─────────────────────────────

final lyricsRepositoryProvider = Provider<LyricsRepository>(
  (ref) => _unimplemented('LyricsRepository'), // P7
);
