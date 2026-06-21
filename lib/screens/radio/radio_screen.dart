import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../state/repository_providers.dart';
import '../../utils/track_song.dart';
import '../../widgets/pressable.dart';
import '../../widgets/section_header.dart';
import '../../widgets/station_tile.dart';

const double _kBottomInset = 158; // clears mini-player + tab bar

/// Screen 07 — Radio.
class RadioScreen extends ConsumerWidget {
  const RadioScreen({super.key});

  /// Starts playback from the default queue and opens Now Playing —
  /// the design's play buttons all route to screen 06.
  void _playAndOpen(BuildContext context, WidgetRef ref) {
    ref.read(playbackControllerProvider).playQueue(
          MockData.sundaySliceTracks.toSongs(),
        );
    context.push('/player');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPad, AppSpacing.sm, AppSpacing.screenPad, _kBottomInset),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 16),
              child: Text('Radio', style: AppType.h2.copyWith(fontSize: 28)),
            ),
            _LiveHero(onPlay: () => _playAndOpen(context, ref)),
            const SizedBox(height: 24),
            const SectionHeader('Popular stations'),
            const SizedBox(height: 8),
            for (final s in MockData.stations)
              StationTile(s, onPlay: () => _playAndOpen(context, ref)),
            const SizedBox(height: 22),
            const SectionHeader('Genre radio'),
            const SizedBox(height: 14),
            const _GenreChips(),
          ],
        ),
      ),
    );
  }
}

/// "Watermelon FM" LIVE hero card.
class _LiveHero extends StatelessWidget {
  final VoidCallback onPlay;
  const _LiveHero({required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 188,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.bgRiver, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.4, -1),
                  end: Alignment(-0.4, 1),
                  colors: [Color(0x597A1020), Color(0xD1000000)],
                ),
              ),
            ),
            const Positioned(top: 14, left: 14, child: _LiveBadge()),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Watermelon FM',
                      style: AppType.h2.copyWith(fontSize: 24, letterSpacing: -0.6)),
                  const SizedBox(height: 5),
                  Text('Fresh summer cuts, all day · 12.4k listening',
                      style: AppType.caption.copyWith(
                          fontSize: 13, color: const Color(0xB8FFFFFF))),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Pressable(
                onTap: onPlay,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(color: Color(0x80FF1A1A), blurRadius: 20, offset: Offset(0, 8)),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Red "LIVE" pill with a softly pulsing dot.
class _LiveBadge extends StatefulWidget {
  const _LiveBadge();

  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: Tween<double>(begin: 1, end: 0.3).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text('LIVE',
              style: AppType.label.copyWith(
                  fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
        ],
      ),
    );
  }
}

class _GenreChips extends StatelessWidget {
  const _GenreChips();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: [
        for (final g in MockData.genres)
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0x14FFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: Text(g, style: AppType.label.copyWith(fontSize: 13)),
          ),
      ],
    );
  }
}
