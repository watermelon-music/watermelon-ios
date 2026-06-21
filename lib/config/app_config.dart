/// App configuration — secrets and backend endpoints.
///
/// Values come from a gitignored `.env` file (loaded via `flutter_dotenv` in
/// `main`). For each key, a compile-time `--dart-define` is used as a fallback,
/// so both `.env` and `--dart-define-from-file` work. No secrets live in the repo.
///
/// Setup: `cp .env.example .env` and fill in your values.
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  /// Read from `.env` first; fall back to a compile-time define.
  static String _resolve(String key, String compileTimeDefault) {
    if (dotenv.isInitialized) {
      final v = dotenv.maybeGet(key);
      if (v != null && v.isNotEmpty) return v;
    }
    return compileTimeDefault;
  }

  // ── Supabase (auth + cloud sync) ─────────────────────────────────────────
  static String get supabaseUrl =>
      _resolve('SUPABASE_URL', const String.fromEnvironment('SUPABASE_URL'));
  static String get supabaseKey =>
      _resolve('SUPABASE_KEY', const String.fromEnvironment('SUPABASE_KEY'));

  // ── Watermelon backend (primary catalog + stream/extraction API) ─────────
  static String get watermelonApiUrl {
    final v = _resolve(
      'WATERMELON_API_URL',
      const String.fromEnvironment('WATERMELON_API_URL'),
    );
    return v.isEmpty ? 'https://watermelon-api-oxx2.onrender.com/' : v;
  }

  // ── Jamendo (creative-commons catalog) ───────────────────────────────────
  static String get jamendoClientId => _resolve(
      'JAMENDO_CLIENT_ID', const String.fromEnvironment('JAMENDO_CLIENT_ID'));

  // ── PodcastIndex (podcasts; SHA-1 epoch auth) ────────────────────────────
  static String get podcastIndexApiKey => _resolve('PODCAST_INDEX_API_KEY',
      const String.fromEnvironment('PODCAST_INDEX_API_KEY'));
  static String get podcastIndexSecret => _resolve('PODCAST_INDEX_SECRET',
      const String.fromEnvironment('PODCAST_INDEX_SECRET'));

  // ── Public APIs (no auth/keys required) ──────────────────────────────────
  static const String audiusHost = 'https://discoveryprovider.audius.co/';
  static const String jamendoBaseUrl = 'https://api.jamendo.com/v3.0/';
  static const String radioBrowserBaseUrl =
      'https://all.api.radio-browser.info/';
  static const String podcastIndexBaseUrl = 'https://api.podcastindex.org/';
  static const String lrcLibBaseUrl = 'https://lrclib.net/';

  /// True once the Supabase credentials have been supplied.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;

  /// True once the Jamendo client id has been supplied.
  static bool get hasJamendo => jamendoClientId.isNotEmpty;

  /// True once the PodcastIndex credentials have been supplied.
  static bool get hasPodcastIndex =>
      podcastIndexApiKey.isNotEmpty && podcastIndexSecret.isNotEmpty;
}
