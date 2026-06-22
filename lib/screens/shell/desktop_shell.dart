import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';
import '../../widgets/desktop/desktop_player_bar.dart';
import '../../widgets/desktop/desktop_sidebar.dart';

/// Desktop / wide-window shell (Apple Music style): a persistent left sidebar
/// and content area, with a full-width transport bar pinned to the bottom.
///
/// Hosts the same [StatefulNavigationShell] branches as the phone layout, so
/// per-tab state is preserved and all existing screens render unchanged in the
/// content area.
class DesktopShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DesktopShell({super.key, required this.navigationShell});

  void _goBranch(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                DesktopSidebar(
                  currentIndex: navigationShell.currentIndex,
                  onSelectBranch: _goBranch,
                ),
                Expanded(
                  child: ClipRect(child: navigationShell),
                ),
              ],
            ),
          ),
          const DesktopPlayerBar(),
        ],
      ),
    );
  }
}
