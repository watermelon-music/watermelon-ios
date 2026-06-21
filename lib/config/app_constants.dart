/// Cross-cutting business constants ported from the Kotlin app.
///
/// Single source of truth for the numeric rules referenced throughout the spec
/// (see `LOGIC_IMPLEMENTATION.md` §10). Feature code should read these rather
/// than hardcoding values.
library;

class AppConstants {
  AppConstants._();

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const int passwordMinLength = 6;

  // ── Playlist limits (free vs premium) ─────────────────────────────────────
  static const int freeMaxPlaylists = 2; // UI-enforced; remote config may raise
  static const int premiumMaxPlaylists = 5;

  // ── Debounce / timing ─────────────────────────────────────────────────────
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration radioSearchDebounce = Duration(milliseconds: 400);
  static const Duration libraryLoadDelay = Duration(milliseconds: 800);
  static const Duration splashMinDwell = Duration(milliseconds: 600);

  // ── Home feed ──────────────────────────────────────────────────────────────
  static const int homeGenreCount = 8;
  static const int homeSongsPerGenre = 7;
  // Daily refresh at 05:30 IST.
  static const int homeRefreshHourIst = 5;
  static const int homeRefreshMinuteIst = 30;

  // ── Radio ──────────────────────────────────────────────────────────────────
  static const int radioBrowseLimit = 100;
  static const int radioSearchLimit = 50;

  // ── Local cache / history caps ─────────────────────────────────────────────
  static const int recentItemsCap = 50;
  static const int historyCap = 50;
  static const int skipsCap = 50;
  static const int cachedSongsPerQuery = 20;
  static const Duration cachedSongsTtl = Duration(hours: 1);

  // ── Catalog content filter (drop non-music by duration) ────────────────────
  static const int minMusicDurationSec = 45;
  static const int maxMusicDurationSec = 720;

  // ── Playback ──────────────────────────────────────────────────────────────
  static const int maxConsecutivePlayErrors = 3;
  static const Duration playErrorRetryDelay = Duration(seconds: 3);
  static const int newPipeBitrateCapKbps = 192;
  static const Duration extractionUrlCacheTtl = Duration(minutes: 10);

  // ── Autoplay queue management ──────────────────────────────────────────────
  static const int autoplayBatchSize = 20;
  static const int autoplayRefillThreshold = 10;

  // ── Daily engagement notification intervals (hours) ────────────────────────
  static const List<int> notificationIntervalHours = [6, 8, 12, 24];
}
