import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';

import 'core/app_logger.dart';
import 'data/remote/supabase/supabase_init.dart';
import 'router.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Windows & Linux have no native just_audio backend — register media_kit
  // (libmpv) for them. macOS/iOS/Android/web use just_audio's own backends.
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    JustAudioMediaKit.ensureInitialized(windows: true, linux: true);
  }
  // Load secrets from .env (no-op if the file is absent).
  try {
    await dotenv.load();
    AppLog.boot('.env loaded', {'keys': dotenv.env.keys.length});
  } catch (e) {
    AppLog.boot('.env load failed (continuing)', {'error': e.toString()});
  }
  // Initialize Supabase if keys are configured (no-op otherwise).
  await initSupabase();
  // Dark-only app: force light status-bar icons on a transparent bar.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const ProviderScope(child: WatermelonApp()));
}

class WatermelonApp extends StatelessWidget {
  const WatermelonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Watermelon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
