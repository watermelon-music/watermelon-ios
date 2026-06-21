import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../state/repository_providers.dart';
import 'cover_image.dart';
import 'like_button.dart';

/// Floating frosted now-playing bar shown above the tab bar. Tapping it opens
/// the full Now Playing screen. Mirrors MiniPlayer.dc.html.
class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackStateProvider);
    final song = state.currentSong;
    if (song == null) return const SizedBox.shrink();
    final progress = state.durationMs > 0
        ? (state.positionMs / state.durationMs).clamp(0.0, 1.0)
        : 0.0;

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
                    widthFactor: progress,
                    child: const ColoredBox(color: Color(0x21FF1A1A)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: CoverImage(song.coverUrl,
                            width: 42, height: 42, iconSize: 18),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(song.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppType.label.copyWith(fontSize: 13)),
                            Text(song.artistName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppType.caption.copyWith(fontSize: 11)),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      LikeButton(id: song.id, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => ref
                            .read(playbackControllerProvider)
                            .togglePlayPause(),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            state.isBuffering
                                ? Icons.hourglass_empty_rounded
                                : (state.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded),
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
