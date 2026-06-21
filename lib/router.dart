import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_config.dart';
import 'core/app_logger.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/player/now_playing_screen.dart';
import 'screens/playlist/playlist_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/radio/radio_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/shell/app_shell.dart';
import 'screens/subscription/subscription_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Pre-auth routes — reachable while signed out. Everything else requires a
/// session (when Supabase is configured).
const _publicRoutes = {'/onboarding', '/login', '/register'};

/// Whether a Supabase session is currently active. Safe to call before
/// `initSupabase` (returns false when Supabase isn't configured/initialized).
bool _isLoggedIn() {
  if (!AppConfig.hasSupabase) return false;
  try {
    return Supabase.instance.client.auth.currentSession != null;
  } catch (_) {
    return false; // client not initialized yet
  }
}

/// App routing: pre-auth flow (onboarding → login/register) → a tabbed shell
/// (home/search/radio/profile). Player, playlist and subscription push above
/// the shell on the root navigator (full-screen, over the tab bar).
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/onboarding',
  observers: [_LogObserver()],
  // Re-run [redirect] whenever the auth session changes (login/logout/refresh).
  refreshListenable: _authRefresh,
  redirect: (context, state) {
    // When Supabase isn't configured, leave routing untouched (mock/dev mode).
    if (!AppConfig.hasSupabase) return null;
    final loggedIn = _isLoggedIn();
    final atPublic = _publicRoutes.contains(state.matchedLocation);

    // Signed in but sitting on an auth screen → drop into the app.
    if (loggedIn && atPublic) {
      AppLog.nav('redirect → /home (already signed in)', {'from': state.matchedLocation});
      return '/home';
    }
    // Signed out but trying to reach a protected screen → bounce to onboarding.
    if (!loggedIn && !atPublic) {
      AppLog.nav('redirect → /onboarding (not signed in)', {'from': state.matchedLocation});
      return '/onboarding';
    }
    return null; // no redirect
  },
  routes: [
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),

    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/radio', builder: (_, _) => const RadioScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ]),
      ],
    ),

    GoRoute(
      path: '/player',
      parentNavigatorKey: _rootKey,
      pageBuilder: (_, _) => _slideUpPage(const NowPlayingScreen()),
    ),
    GoRoute(
      path: '/playlist/:id',
      parentNavigatorKey: _rootKey,
      builder: (_, state) =>
          PlaylistScreen(id: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/subscription',
      parentNavigatorKey: _rootKey,
      pageBuilder: (_, _) => _slideUpPage(const SubscriptionScreen()),
    ),
  ],
);

/// Bridges Supabase's auth-state stream to a [Listenable] so go_router's
/// `refreshListenable` re-evaluates `redirect` on login/logout/token refresh.
final _authRefresh = _AuthRefreshListenable();

class _AuthRefreshListenable extends ChangeNotifier {
  StreamSubscription<AuthState>? _sub;

  _AuthRefreshListenable() {
    if (AppConfig.hasSupabase) {
      try {
        _sub = Supabase.instance.client.auth.onAuthStateChange.listen((event) {
          AppLog.auth('authStateChange', {'event': event.event.name});
          notifyListeners();
        });
      } catch (_) {
        // Supabase not initialized — redirect stays in signed-out mode.
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// Logs route pushes/pops so the navigation path is visible in `flutter logs`.
class _LogObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLog.nav('push', {'to': route.settings.name ?? route.settings.arguments});
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLog.nav('pop', {'from': route.settings.name});
  }
}

/// Modal-style "slide up from the bottom" transition used for the full-screen
/// Now Playing and Subscription routes.
CustomTransitionPage<void> _slideUpPage(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}
