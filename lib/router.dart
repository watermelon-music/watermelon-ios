import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

/// App routing: pre-auth flow (onboarding → login/register) → a tabbed shell
/// (home/search/radio/profile). Player, playlist and subscription push above
/// the shell on the root navigator (full-screen, over the tab bar).
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/onboarding',
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
