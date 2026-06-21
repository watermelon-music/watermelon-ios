import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/track.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../state/repository_providers.dart';
import '../utils/track_song.dart';
import 'like_button.dart';

/// A track row used in the playlist track list: optional leading number,
/// artwork, title/artist, like heart, and a mono duration. The title turns red
/// when this track is the current now-playing track.
class TrackTile extends ConsumerWidget {
  final Track track;
  final int? index; // 1-based number, null to hide
  final List<Track> queue;

  const TrackTile({
    super.key,
    required this.track,
    this.queue = const [],
    this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrent = ref.watch(
      playbackStateProvider.select((s) => s.currentSong?.id == track.id),
    );

    return InkWell(
      onTap: () {
        final tracks = queue.isEmpty ? [track] : queue;
        final start = tracks.indexWhere((t) => t.id == track.id);
        ref.read(playbackControllerProvider).playQueue(
              tracks.toSongs(),
              startIndex: start < 0 ? 0 : start,
            );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            if (index != null) ...[
              SizedBox(
                width: 18,
                child: Text('$index',
                    textAlign: TextAlign.center, style: AppType.mono),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Image.asset(track.art, width: 46, height: 46, fit: BoxFit.cover),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.label.copyWith(
                      fontSize: 14.5,
                      color: isCurrent ? AppColors.primaryBright : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(track.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.caption),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            LikeButton(id: track.id, size: 18, padding: const EdgeInsets.all(4)),
            const SizedBox(width: AppSpacing.sm),
            Text(track.durationLabel, style: AppType.mono),
          ],
        ),
      ),
    );
  }
}
