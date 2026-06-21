import 'package:flutter/foundation.dart';

/// Lightweight app-wide logger. Uses [debugPrint] so entries reliably show up
/// in the `flutter run` / `flutter logs` console (unlike `dart:developer.log`,
/// which only surfaces in the VM service / DevTools). Stripped in release.
///
/// Output format: `🍉 watermelon.auth: signIn start {email=...}`
///
/// Usage: `AppLog.auth('signIn start', {'email': email});`
class AppLog {
  AppLog._();

  static const _enabled = !kReleaseMode;

  static void _emit(
    String tag,
    String message, {
    Object? data,
    Object? error,
    StackTrace? stackTrace,
    int level = 0,
  }) {
    if (!_enabled) return;
    final suffix = data == null ? '' : ' ${_fmt(data)}';
    final marker = level >= 900 ? '🍉❌' : '🍉';
    debugPrint('$marker watermelon.$tag: $message$suffix');
    if (error != null) debugPrint('   ↳ error: $error');
    if (stackTrace != null) debugPrint('   ↳ $stackTrace');
  }

  /// Auth flow (sign in / up / out, session changes).
  static void auth(String message, [Object? data]) =>
      _emit('auth', message, data: data);

  /// App bootstrap (Supabase init, config, env).
  static void boot(String message, [Object? data]) =>
      _emit('boot', message, data: data);

  /// Navigation / routing decisions.
  static void nav(String message, [Object? data]) =>
      _emit('nav', message, data: data);

  /// An error with optional context. Logged at warning level.
  static void error(String tag, String message,
          {Object? error, StackTrace? stackTrace, Object? data}) =>
      _emit(tag, message,
          data: data, error: error, stackTrace: stackTrace, level: 900);

  static String _fmt(Object data) {
    if (data is Map) {
      return '{${data.entries.map((e) => '${e.key}=${e.value}').join(', ')}}';
    }
    return data.toString();
  }
}
