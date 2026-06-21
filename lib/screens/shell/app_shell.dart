import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';
import '../../widgets/mini_player.dart';
import '../../widgets/watermelon_tab_bar.dart';

/// The tabbed shell: hosts the 4 tab branches in an IndexedStack (state
/// preserved per tab) with a persistent mini-player + tab bar overlaid at the
/// bottom. Full-screen routes (player, playlist, subscription) push above this.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: Stack(
        children: [
          navigationShell,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: MiniPlayer(),
                ),
                WatermelonTabBar(
                  currentIndex: navigationShell.currentIndex,
                  onSelect: (i) => navigationShell.goBranch(
                    i,
                    initialLocation: i == navigationShell.currentIndex,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
