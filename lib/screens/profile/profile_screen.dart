import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/playlist.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_icon.dart';

const double _kBottomInset = 158; // clears mini-player + tab bar

/// Screen 09 — Profile.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Wine glow behind the header.
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x807A1020), Color(0x00000000)],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPad, AppSpacing.sm, AppSpacing.screenPad, _kBottomInset),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: AppIcon(AppAssets.settings, size: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const _ProfileHeader(),
                const SizedBox(height: 24),
                _PremiumCard(onTap: () => context.push('/subscription')),
                const SizedBox(height: 26),
                Text('Your playlists', style: AppType.sectionTitle),
                const SizedBox(height: 13),
                const _PlaylistsGrid(),
                const SizedBox(height: 24),
                const _SettingsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x2EFFFFFF), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0x80000000), blurRadius: 30, offset: Offset(0, 12)),
            ],
            image: const DecorationImage(
              image: AssetImage(AppAssets.melonWhole),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(MockData.userFullName,
            style: AppType.h2.copyWith(fontSize: 24, letterSpacing: -0.6)),
        const SizedBox(height: 5),
        Text(MockData.userHandle,
            style: AppType.bodySm.copyWith(
                fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 18),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Stat(value: '${MockData.followers}', label: 'Followers'),
              const _StatDivider(),
              _Stat(value: '${MockData.following}', label: 'Following'),
              const _StatDivider(),
              _Stat(value: '${MockData.playlistCount}', label: 'Playlists'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 28),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: const Color(0x38FFFFFF), width: 1.5),
            ),
            child: Text('Edit profile',
                style: AppType.label.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        children: [
          Text(value, style: AppType.h2.copyWith(fontSize: 18, letterSpacing: 0)),
          const SizedBox(height: 5),
          Text(label,
              style: AppType.caption.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, color: const Color(0x1FFFFFFF));
  }
}

/// Watermelon Premium upgrade card → Subscription.
class _PremiumCard extends StatelessWidget {
  final VoidCallback onTap;
  const _PremiumCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.9, -0.4),
                    end: Alignment(0.9, 0.4),
                    colors: [AppColors.primary, AppColors.wineDeep],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -6,
              bottom: -10,
              child: Opacity(
                opacity: 0.85,
                child: Transform.rotate(
                  angle: -0.21, // ≈ -12°
                  child: Image.asset(AppAssets.logoSlice,
                      width: 78, height: 78, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Watermelon Premium',
                      style: AppType.title.copyWith(fontSize: 17, letterSpacing: -0.2)),
                  const SizedBox(height: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text('Ad-free, offline, hi-fi lossless. Try 1 month free.',
                        style: AppType.bodySm.copyWith(
                            fontSize: 13, height: 1.45, color: const Color(0xD9FFFFFF))),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 34,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text('Upgrade',
                        style: AppType.label.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.wineDeep)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistsGrid extends StatelessWidget {
  const _PlaylistsGrid();

  @override
  Widget build(BuildContext context) {
    final items = MockData.myPlaylists;
    return Column(
      children: [
        for (var i = 0; i < items.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _PlaylistItem(items[i])),
                const SizedBox(width: 14),
                Expanded(
                  child: i + 1 < items.length
                      ? _PlaylistItem(items[i + 1])
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PlaylistItem extends StatelessWidget {
  final PlaylistRef item;
  const _PlaylistItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Image.asset(item.art, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        Text(item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.label.copyWith(fontSize: 14)),
        const SizedBox(height: 2),
        Text(item.subtitle, style: AppType.caption),
      ],
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList();

  @override
  Widget build(BuildContext context) {
    final rows = MockData.settingsRows;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: i == rows.length - 1
                      ? null
                      : const Border(
                          bottom: BorderSide(color: Color(0x12FFFFFF), width: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(rows[i],
                          style: AppType.body.copyWith(fontSize: 15)),
                    ),
                    const AppIcon(AppAssets.chevronRight,
                        size: 14, color: AppColors.textTertiary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
