import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../state/player_controller.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/pressable.dart';
import '../../widgets/section_header.dart';

const double _kBottomInset = 158; // clears mini-player + tab bar

/// Screen 04 — Home.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Wine glow behind the header.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x8C7A1020), Color(0x00000000)],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPad, AppSpacing.md, AppSpacing.screenPad, _kBottomInset),
              children: [
                const _GreetingHeader(),
                const SizedBox(height: AppSpacing.lg),
                const _FilterChips(),
                const SizedBox(height: AppSpacing.lg),
                const _JumpBackGrid(),
                const SizedBox(height: 26),
                const SectionHeader('Made for Avery', large: true),
                const SizedBox(height: 14),
                _FeatureCard(
                  onPlay: () {
                    ref.read(playerProvider.notifier).play(
                          MockData.sundaySliceTracks.first,
                          queue: MockData.sundaySliceTracks,
                        );
                    context.push('/player');
                  },
                ),
                const SizedBox(height: 26),
                const SectionHeader('New releases', large: true),
                const SizedBox(height: 14),
                _NewReleasesGrid(
                  onTap: (t) => ref.read(playerProvider.notifier).play(t),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good evening',
                  style: AppType.bodySm.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(MockData.userName,
                  style: AppType.h2.copyWith(fontSize: 23, letterSpacing: -0.6)),
            ],
          ),
        ),
        const AppIcon(AppAssets.bell, size: 23),
        const SizedBox(width: 12),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x4DFFFFFF), width: 1.5),
            image: const DecorationImage(
              image: AssetImage(AppAssets.melonWhole),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatefulWidget {
  const _FilterChips();

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  static const _labels = ['All', 'Music', 'Podcasts'];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 9),
              child: GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: Container(
                  height: 34,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: i == _selected ? AppColors.primary : const Color(0x1AFFFFFF),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(_labels[i],
                      style: AppType.label.copyWith(fontSize: 13)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _JumpBackGrid extends StatelessWidget {
  const _JumpBackGrid();

  @override
  Widget build(BuildContext context) {
    final items = MockData.jumpBack;
    return Column(
      children: [
        for (var i = 0; i < items.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              children: [
                Expanded(child: _JumpBackTile(items[i])),
                const SizedBox(width: 9),
                Expanded(
                  child: i + 1 < items.length
                      ? _JumpBackTile(items[i + 1])
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _JumpBackTile extends StatelessWidget {
  final PlaylistRef item;
  const _JumpBackTile(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0x12FFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          Image.asset(item.art, width: 58, height: 58, fit: BoxFit.cover),
          const SizedBox(width: 11),
          Expanded(
            child: Text(item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.label.copyWith(fontSize: 12.5)),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final VoidCallback onPlay;
  const _FeatureCard({required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.bgRiver, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x1A000000), Color(0xC7000000)],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Mix 01'.toUpperCase(),
                      style: AppType.overline.copyWith(
                          color: const Color(0xFFFF8A8A), letterSpacing: 1.5)),
                  const SizedBox(height: 7),
                  Text('Riverside Rinds',
                      style: AppType.h2.copyWith(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text('Rind & Vine · Mara Lune · Juno Pith',
                      style: AppType.bodySm.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: Pressable(
                onTap: onPlay,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(color: Color(0x80FF1A1A), blurRadius: 20, offset: Offset(0, 8)),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewReleasesGrid extends StatelessWidget {
  final void Function(Track) onTap;
  const _NewReleasesGrid({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = MockData.newReleases;
    return Column(
      children: [
        for (var i = 0; i < items.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _ReleaseItem(items[i], onTap: () => onTap(items[i]))),
                const SizedBox(width: 14),
                Expanded(
                  child: i + 1 < items.length
                      ? _ReleaseItem(items[i + 1], onTap: () => onTap(items[i + 1]))
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ReleaseItem extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  const _ReleaseItem(this.track, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.asset(track.art, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 9),
          Text(track.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.label.copyWith(fontSize: 14)),
          const SizedBox(height: 2),
          Text(track.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.caption),
        ],
      ),
    );
  }
}
