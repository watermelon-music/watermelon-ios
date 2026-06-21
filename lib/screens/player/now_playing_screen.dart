import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../utils/format.dart';
import '../../state/player_controller.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/like_button.dart';
import '../../widgets/pressable.dart';

/// Screen 06 — Now Playing.
class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final track = player.track ?? MockData.nowPlayingDefault;
    final notifier = ref.read(playerProvider.notifier);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.playerGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
            child: Column(
              children: [
                _Header(onClose: () => context.pop()),
                const SizedBox(height: 30),
                // Artwork.
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: AppShadow.artwork,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(track.art, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 34),
                // Title + like.
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(track.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.h2.copyWith(fontSize: 26, letterSpacing: -0.8)),
                          const SizedBox(height: 5),
                          Text(track.artist,
                              style: AppType.body.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    LikeButton(
                        id: track.id, size: 28, inactiveColor: AppColors.textPrimary),
                  ],
                ),
                const SizedBox(height: 24),
                _Scrubber(
                  progress: player.progress,
                  elapsed: formatDuration(player.position),
                  remaining: formatRemaining(player.duration, player.position),
                  onSeek: notifier.seekFraction,
                ),
                const SizedBox(height: 20),
                _Transport(player: player, notifier: notifier),
                const Spacer(),
                const _BottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onClose;
  const _Header({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
        ),
        Expanded(
          child: Column(
            children: [
              Text('Playing from playlist'.toUpperCase(),
                  style: AppType.overline.copyWith(
                      fontSize: 10.5, color: AppColors.textSecondary)),
              const SizedBox(height: 3),
              Text('Sunday Slice',
                  style: AppType.label.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        const AppIcon(AppAssets.moreHoriz, size: 22),
      ],
    );
  }
}

class _Scrubber extends StatelessWidget {
  final double progress;
  final String elapsed;
  final String remaining;
  final ValueChanged<double> onSeek;

  const _Scrubber({
    required this.progress,
    required this.elapsed,
    required this.remaining,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 5,
            activeTrackColor: Colors.white,
            inactiveTrackColor: const Color(0x2EFFFFFF),
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.5),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(value: progress.clamp(0, 1), onChanged: onSeek),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(elapsed, style: AppType.mono.copyWith(fontSize: 11)),
              Text(remaining, style: AppType.mono.copyWith(fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Transport extends StatelessWidget {
  final PlayerState player;
  final PlayerController notifier;
  const _Transport({required this.player, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: notifier.toggleShuffle,
          child: AppIcon(AppAssets.shuffle,
              size: 24,
              color: player.shuffle ? AppColors.primaryBright : AppColors.textSecondary),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: notifier.previous,
          child: const AppIcon(AppAssets.skipPrev, size: 34),
        ),
        // Play / pause — 78px white circle.
        Pressable(
          onTap: notifier.toggle,
          child: Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x66000000), blurRadius: 30, offset: Offset(0, 10))],
            ),
            child: Icon(
              player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: AppColors.wineDeep,
              size: 38,
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: notifier.next,
          child: const AppIcon(AppAssets.skipNext, size: 34),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: notifier.cycleRepeat,
          child: AppIcon(AppAssets.repeat,
              size: 24,
              color: player.repeat == LoopMode.off
                  ? AppColors.textSecondary
                  : AppColors.primaryBright),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppIcon(AppAssets.lyrics, size: 22, color: AppColors.textSecondary),
          const AppIcon(AppAssets.devices, size: 22, color: AppColors.textSecondary),
          Row(
            children: [
              const AppIcon(AppAssets.queue, size: 15),
              const SizedBox(width: 6),
              Text('QUEUE',
                  style: AppType.label.copyWith(fontSize: 12, letterSpacing: 1)),
            ],
          ),
        ],
      ),
    );
  }
}
