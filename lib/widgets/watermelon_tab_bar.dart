import 'package:flutter/material.dart';

import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

class _Tab {
  final String label;
  final String icon;
  const _Tab(this.label, this.icon);
}

/// Bottom tab bar — 4 tabs over a black-to-transparent fade. The active tab is
/// red. Mirrors TabBar.dc.html.
class WatermelonTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const WatermelonTabBar({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  static const List<_Tab> _tabs = [
    _Tab('Home', AppAssets.home),
    _Tab('Search', AppAssets.search),
    _Tab('Radio', AppAssets.radio),
    _Tab('Profile', AppAssets.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [AppColors.black, AppColors.black, Color(0x00000000)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < _tabs.length; i++)
                _TabButton(
                  tab: _tabs[i],
                  active: i == currentIndex,
                  onTap: () => onSelect(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final _Tab tab;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({required this.tab, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textTertiary;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active tab pops slightly to confirm the switch.
            AnimatedScale(
              scale: active ? 1.12 : 1.0,
              duration: AppMotion.base,
              curve: AppMotion.curve,
              child: AppIcon(tab.icon, size: 25, color: color),
            ),
            const SizedBox(height: 5),
            Text(tab.label,
                style: AppType.caption.copyWith(
                    fontSize: 10, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}
