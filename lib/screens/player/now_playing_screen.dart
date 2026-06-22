import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/song.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_breakpoints.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../utils/format.dart';
import '../../state/playback_controller.dart';
import '../../state/repository_providers.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/cover_image.dart';
import '../../widgets/download_button.dart';
import '../../widgets/like_button.dart';
import '../../widgets/pressable.dart';

/// Screen 06 — Now Playing.
class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackStateProvider);
    final controller = ref.read(playbackControllerProvider);
    final song = state.currentSong;

    if (song == null) {
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppColors.playerGradient),
          child: SafeArea(
            child: Column(
              children: [
                _Header(onClose: () => context.pop()),
                const Spacer(),
                Center(
                  child: Text('Nothing playing',
                      style: AppType.body
                          .copyWith(color: AppColors.textSecondary)),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.playerGradient),
        child: SafeArea(
          // Decide from the actual available width (robust inside the pushed
          // modal route) rather than the window-level MediaQuery.
          child: LayoutBuilder(
            builder: (context, constraints) =>
                constraints.maxWidth >= AppBreakpoints.desktop
                    ? _DesktopPlayerBody(
                        state: state, controller: controller, song: song)
                    : _MobilePlayerBody(
                        state: state, controller: controller, song: song),
          ),
        ),
      ),
    );
  }
}

/// Phone layout — a vertical stack that fills the screen width (unchanged).
class _MobilePlayerBody extends StatelessWidget {
  final PlaybackState state;
  final PlaybackController controller;
  final Song song;
  const _MobilePlayerBody(
      {required this.state, required this.controller, required this.song});

  @override
  Widget build(BuildContext context) {
    final position = Duration(milliseconds: state.positionMs);
    final duration = Duration(milliseconds: state.durationMs);
    final progress = state.durationMs > 0
        ? (state.positionMs / state.durationMs).clamp(0.0, 1.0)
        : 0.0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 8, 26, 20),
      child: Column(
        children: [
          _Header(onClose: () => context.pop()),
          const SizedBox(height: 30),
          _Artwork(song: song, iconSize: 64),
          const SizedBox(height: 34),
          _TitleRow(song: song),
          const SizedBox(height: 24),
          _Scrubber(
            progress: progress.toDouble(),
            elapsed: formatDuration(position),
            remaining: formatRemaining(duration, position),
            onSeek: (f) => controller.seekTo((state.durationMs * f).round()),
          ),
          const SizedBox(height: 20),
          _Transport(state: state, controller: controller),
          const Spacer(),
          const _BottomBar(),
        ],
      ),
    );
  }
}

/// Desktop / wide layout — centered and width-constrained, with artwork that
/// scales to the available height instead of stretching across the window.
class _DesktopPlayerBody extends StatelessWidget {
  final PlaybackState state;
  final PlaybackController controller;
  final Song song;
  const _DesktopPlayerBody(
      {required this.state, required this.controller, required this.song});

  @override
  Widget build(BuildContext context) {
    final position = Duration(milliseconds: state.positionMs);
    final duration = Duration(milliseconds: state.durationMs);
    final progress = state.durationMs > 0
        ? (state.positionMs / state.durationMs).clamp(0.0, 1.0)
        : 0.0;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 14, 32, 30),
          child: Column(
            children: [
              _Header(onClose: () => context.pop()),
              const SizedBox(height: 22),
              // Artwork fills the available vertical space, capped square.
              Expanded(child: Center(child: _Artwork(song: song, iconSize: 84))),
              const SizedBox(height: 30),
              _TitleRow(song: song),
              const SizedBox(height: 22),
              _Scrubber(
                progress: progress.toDouble(),
                elapsed: formatDuration(position),
                remaining: formatRemaining(duration, position),
                onSeek: (f) => controller.seekTo((state.durationMs * f).round()),
              ),
              const SizedBox(height: 18),
              _Transport(state: state, controller: controller),
              const SizedBox(height: 24),
              const _BottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square album artwork with the rounded corners + drop shadow.
class _Artwork extends StatelessWidget {
  final Song song;
  final double iconSize;
  const _Artwork({required this.song, this.iconSize = 64});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadow.artwork,
        ),
        clipBehavior: Clip.antiAlias,
        child: CoverImage(song.coverUrl, iconSize: iconSize),
      ),
    );
  }
}

/// Track title + artist with a like button trailing.
class _TitleRow extends StatelessWidget {
  final Song song;
  const _TitleRow({required this.song});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.h2.copyWith(fontSize: 26, letterSpacing: -0.8)),
              const SizedBox(height: 5),
              Text(song.artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.body.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        LikeButton(
            id: song.id, size: 28, inactiveColor: AppColors.textPrimary),
      ],
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
  final PlaybackState state;
  final PlaybackController controller;
  const _Transport({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: controller.toggleShuffle,
          child: AppIcon(AppAssets.shuffle,
              size: 24,
              color: state.isShuffled ? AppColors.primaryBright : AppColors.textSecondary),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: controller.previous,
          child: const AppIcon(AppAssets.skipPrev, size: 34),
        ),
        // Play / pause — 78px white circle.
        Pressable(
          onTap: controller.togglePlayPause,
          child: Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x66000000), blurRadius: 30, offset: Offset(0, 10))],
            ),
            child: Icon(
              state.isBuffering
                  ? Icons.hourglass_empty_rounded
                  : (state.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded),
              color: AppColors.wineDeep,
              size: 38,
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: controller.next,
          child: const AppIcon(AppAssets.skipNext, size: 34),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: controller.cycleRepeat,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AppIcon(AppAssets.repeat,
                  size: 24,
                  color: state.repeatMode == RepeatMode.none
                      ? AppColors.textSecondary
                      : AppColors.primaryBright),
              if (state.repeatMode == RepeatMode.one)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Text('1',
                      style: AppType.mono.copyWith(
                          fontSize: 10,
                          color: AppColors.primaryBright,
                          fontWeight: FontWeight.w800)),
                ),
            ],
          ),
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
          const _CurrentSongDownload(),
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

/// Download control bound to the current song.
class _CurrentSongDownload extends ConsumerWidget {
  const _CurrentSongDownload();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(playbackStateProvider.select((s) => s.currentSong));
    if (song == null) {
      return const AppIcon(AppAssets.download, size: 22, color: AppColors.textSecondary);
    }
    return DownloadButton(song);
  }
}
