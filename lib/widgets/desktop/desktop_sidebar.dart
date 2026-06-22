import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../state/repository_providers.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../app_icon.dart';
import '../cover_image.dart';

/// Apple-Music–style left navigation rail for the desktop shell.
///
/// Top: brand mark. Then the primary nav (mapped onto the existing shell
/// branches Home/Search/Radio + a Premium push). A divider, then a scrollable
/// "Your Library" list (Liked Songs + playlists). An account chip pinned to the
/// bottom selects the Profile branch.
class DesktopSidebar extends ConsumerWidget {
  /// Current shell branch index (0 Home, 1 Search, 2 Radio, 3 Profile).
  final int currentIndex;

  /// Switch to a shell branch by index.
  final ValueChanged<int> onSelectBranch;

  const DesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.onSelectBranch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    return Container(
      width: 248,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Brand(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _NavItem(
                  icon: AppAssets.home,
                  label: 'Home',
                  active: currentIndex == 0,
                  onTap: () => onSelectBranch(0),
                ),
                _NavItem(
                  icon: AppAssets.search,
                  label: 'Search',
                  active: currentIndex == 1,
                  onTap: () => onSelectBranch(1),
                ),
                _NavItem(
                  icon: AppAssets.radio,
                  label: 'Radio',
                  active: currentIndex == 2,
                  onTap: () => onSelectBranch(2),
                ),
                _NavItem(
                  icon: AppAssets.heart,
                  label: 'Premium',
                  active: location == '/subscription',
                  onTap: () => context.push('/subscription'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, AppSpacing.lg, 22, AppSpacing.sm),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('YOUR LIBRARY', style: AppType.overline),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, AppSpacing.md),
              children: [
                _LibraryItem(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(Icons.favorite_rounded,
                        size: 19, color: Colors.white),
                  ),
                  title: 'Liked Songs',
                  subtitle: 'Playlist',
                  onTap: () => context.push('/playlist/sunday-slice'),
                ),
                for (final p in MockData.myPlaylists)
                  _LibraryItem(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: CoverImage(p.art,
                          width: 40, height: 40, iconSize: 16),
                    ),
                    title: p.title,
                    subtitle: p.subtitle.isEmpty ? 'Playlist' : p.subtitle,
                    onTap: () => context.push('/playlist/sunday-slice'),
                  ),
              ],
            ),
          ),
          const _Divider(),
          _AccountChip(
            name: ref.watch(userDisplayNameProvider),
            handle: ref.watch(userHandleProvider),
            active: currentIndex == 3,
            onTap: () => onSelectBranch(3),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      child: Row(
        children: [
          Image.asset(AppAssets.logoSlice, width: 30, height: 30),
          const SizedBox(width: 10),
          Text('Watermelon',
              style: AppType.title.copyWith(fontSize: 20, letterSpacing: -0.5)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Divider(height: 1, thickness: 1, color: AppColors.border),
    );
  }
}

/// Primary nav row with a hover highlight and an active red pill.
class _NavItem extends StatefulWidget {
  final String icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.active ? AppColors.primary : AppColors.textSecondary;
    final bg = widget.active
        ? const Color(0x1FFF1A1A)
        : (_hover ? AppColors.fillSubtle : Colors.transparent);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              AppIcon(widget.icon, size: 21, color: color),
              const SizedBox(width: 14),
              Text(
                widget.label,
                style: AppType.label.copyWith(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: widget.active ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A row in the scrollable "Your Library" section.
class _LibraryItem extends StatefulWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LibraryItem({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_LibraryItem> createState() => _LibraryItemState();
}

class _LibraryItemState extends State<_LibraryItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _hover ? AppColors.fillSubtle : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              widget.leading,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.label.copyWith(fontSize: 13.5)),
                    const SizedBox(height: 2),
                    Text(widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Account row pinned to the sidebar bottom; selects the Profile branch.
class _AccountChip extends StatefulWidget {
  final String name;
  final String handle;
  final bool active;
  final VoidCallback onTap;

  const _AccountChip({
    required this.name,
    required this.handle,
    required this.active,
    required this.onTap,
  });

  @override
  State<_AccountChip> createState() => _AccountChipState();
}

class _AccountChipState extends State<_AccountChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (widget.active || _hover)
                ? AppColors.fillSubtle
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surfaceHigh,
                backgroundImage: const AssetImage(AppAssets.melonWhole),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.label.copyWith(
                            fontSize: 13.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(widget.handle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              const AppIcon(AppAssets.settings,
                  size: 17, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
