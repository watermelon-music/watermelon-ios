import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../state/player_controller.dart';
import 'like_button.dart';

/// Floating frosted now-playing bar shown above the tab bar. Tapping it opens
/// the full Now Playing screen. Mirrors MiniPlayer.dc.html.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final track = player.track;
    if (track == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => context.push('/player'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: AppSize.miniPlayerHeight,
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadow.floating,
            ),
            child: Stack(
              children: [
                // Progress tint fill.
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: player.progress,
                    child: const ColoredBox(color: Color(0x21FF1A1A)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.asset(track.art,
                            width: 42, height: 42, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(track.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppType.label.copyWith(fontSize: 13)),
                            Text(track.artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppType.caption.copyWith(fontSize: 11)),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      LikeButton(id: track.id, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => ref.read(playerProvider.notifier).toggle(),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            player.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
