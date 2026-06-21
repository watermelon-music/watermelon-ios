import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../config/app_config.dart';
import '../../../core/app_logger.dart';

/// Initialize Supabase if credentials are configured. Call once before
/// `runApp` (after `WidgetsFlutterBinding.ensureInitialized()`). No-op when keys
/// are absent so the app still boots (UI/mock paths keep working).
Future<bool> initSupabase() async {
  if (!AppConfig.hasSupabase) {
    AppLog.boot('Supabase NOT configured — auth/cloud disabled', {
      'hasUrl': AppConfig.supabaseUrl.isNotEmpty,
      'hasKey': AppConfig.supabaseKey.isNotEmpty,
    });
    return false;
  }
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabaseKey,
    );
    AppLog.boot('Supabase initialized', {
      'url': AppConfig.supabaseUrl,
      'session': Supabase.instance.client.auth.currentSession != null,
    });
    return true;
  } catch (e, st) {
    AppLog.error('boot', 'Supabase.initialize failed', error: e, stackTrace: st);
    return false;
  }
}
