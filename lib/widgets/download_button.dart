import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/song.dart';
import '../state/download_manager.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

/// Reusable download control for a [song]: tap to download its audio to disk
/// (YouTube via on-device extraction). Shows a progress ring while fetching and
/// a green check once stored locally (tap again to remove). Used on the Now
/// Playing screen and in search results.
class DownloadButton extends ConsumerWidget {
  final Song song;
  final double size;
  const DownloadButton(this.song, {super.key, this.size = 22});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(downloadManagerProvider)[song.id];
    final downloaded = (info?.phase == DownloadPhase.done) ||
        (ref.watch(isDownloadedProvider(song.id)).asData?.value ?? false);

    if (info?.phase == DownloadPhase.downloading) {
      final p = info!.progress;
      return SizedBox(
        width: size + 4,
        height: size + 4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: p > 0 ? p : null,
                strokeWidth: 2.2,
                color: AppColors.primaryBright,
                backgroundColor: const Color(0x33FFFFFF),
              ),
            ),
            Text('${(p * 100).round()}',
                style: AppType.mono
                    .copyWith(fontSize: 8, color: AppColors.textPrimary)),
          ],
        ),
      );
    }

    if (downloaded) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ref.read(downloadManagerProvider.notifier).delete(song),
        child: Icon(Icons.download_done_rounded,
            size: size + 2, color: AppColors.rindGreen),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ref.read(downloadManagerProvider.notifier).download(song),
      child: AppIcon(AppAssets.download, size: size, color: AppColors.textSecondary),
    );
  }
}
