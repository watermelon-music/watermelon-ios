import 'package:flutter/material.dart';

import '../models/station.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';

/// A "Popular stations" row (Radio): artwork, name, genre · listeners, and a
/// circular outline play button.
class StationTile extends StatelessWidget {
  final Station station;
  final VoidCallback? onPlay;

  const StationTile(this.station, {super.key, this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Image.asset(station.art, width: 54, height: 54, fit: BoxFit.cover),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(station.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.label.copyWith(fontSize: 15)),
                const SizedBox(height: 3),
                Text('${station.genre} · ${station.listeners} live',
                    style: AppType.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Pressable(
            onTap: onPlay,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textTertiary, width: 1.5),
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  size: 20, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
