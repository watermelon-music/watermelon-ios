import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/song.dart';
import '../../state/playback_controller.dart';
import '../../state/repository_providers.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_breakpoints.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../utils/format.dart';
import '../app_icon.dart';
import '../cover_image.dart';
import '../like_button.dart';

/// Persistent full-width transport bar at the bottom of the desktop shell.
///
/// Left: artwork + title/artist + like (tap → full Now Playing). Center:
/// transport controls + scrubber. Right: queue, volume, expand. Reuses the live
/// [PlaybackController]; shows a subdued empty state when nothing is playing.
class DesktopPlayerBar extends ConsumerWidget {
  const DesktopPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackStateProvider);
    final controller = ref.read(playbackControllerProvider);
    final song = state.currentSong;

    return Container(
      height: AppBreakpoints.playerBarHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          // ── Now-playing meta ──
          Expanded(
            flex: 3,
            child: song == null
                ? Text('Not playing',
                    style: AppType.caption.copyWith(color: AppColors.textTertiary))
                : _NowPlayingMeta(song: song),
          ),
          // ── Transport + scrubber ──
          Expanded(
            flex: 4,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Transport(state: state, controller: controller),
                    const SizedBox(height: 6),
                    _Scrubber(state: state, controller: controller),
                  ],
                ),
              ),
            ),
          ),
          // ── Right utilities ──
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _IconBtn(
                  icon: AppAssets.queue,
                  tooltip: 'Queue',
                  enabled: song != null,
                  onTap: () => context.push('/player'),
                ),
                const SizedBox(width: AppSpacing.sm),
                const _VolumeControl(),
                const SizedBox(width: AppSpacing.sm),
                _IconBtn(
                  icon: AppAssets.devices,
                  tooltip: 'Open Now Playing',
                  enabled: song != null,
                  onTap: () => context.push('/player'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NowPlayingMeta extends StatelessWidget {
  final Song song;
  const _NowPlayingMeta({required this.song});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.push('/player'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: CoverImage(song.coverUrl,
                  width: 54, height: 54, iconSize: 20),
            ),
          ),
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
                  style: AppType.label.copyWith(fontSize: 13.5)),
              const SizedBox(height: 3),
              Text(song.artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.caption.copyWith(fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        LikeButton(id: song.id, size: 20),
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
    final enabled = state.currentSong != null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _IconBtn(
          icon: AppAssets.shuffle,
          tooltip: 'Shuffle',
          size: 19,
          enabled: enabled,
          color: state.isShuffled ? AppColors.primary : AppColors.textSecondary,
          onTap: controller.toggleShuffle,
        ),
        const SizedBox(width: AppSpacing.lg),
        _IconBtn(
          icon: AppAssets.skipPrev,
          tooltip: 'Previous',
          size: 26,
          color: AppColors.textPrimary,
          enabled: enabled && state.hasPrevious,
          onTap: controller.previous,
        ),
        const SizedBox(width: AppSpacing.md),
        // Play / pause — white circle.
        _PlayButton(state: state, controller: controller),
        const SizedBox(width: AppSpacing.md),
        _IconBtn(
          icon: AppAssets.skipNext,
          tooltip: 'Next',
          size: 26,
          color: AppColors.textPrimary,
          enabled: enabled,
          onTap: controller.next,
        ),
        const SizedBox(width: AppSpacing.lg),
        _RepeatButton(state: state, controller: controller, enabled: enabled),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  final PlaybackState state;
  final PlaybackController controller;
  const _PlayButton({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final enabled = state.currentSong != null;
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? controller.togglePlayPause : null,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled ? Colors.white : AppColors.surfaceHigh,
          ),
          child: Icon(
            state.isBuffering
                ? Icons.hourglass_empty_rounded
                : (state.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded),
            color: enabled ? AppColors.wineDeep : AppColors.textTertiary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _RepeatButton extends StatelessWidget {
  final PlaybackState state;
  final PlaybackController controller;
  final bool enabled;
  const _RepeatButton({
    required this.state,
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final on = state.repeatMode != RepeatMode.none;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _IconBtn(
          icon: AppAssets.repeat,
          tooltip: 'Repeat',
          size: 19,
          enabled: enabled,
          color: on ? AppColors.primary : AppColors.textSecondary,
          onTap: controller.cycleRepeat,
        ),
        if (state.repeatMode == RepeatMode.one)
          Positioned(
            right: 2,
            top: -2,
            child: Text('1',
                style: AppType.mono.copyWith(
                    fontSize: 9,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800)),
          ),
      ],
    );
  }
}

class _Scrubber extends StatelessWidget {
  final PlaybackState state;
  final PlaybackController controller;
  const _Scrubber({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final position = Duration(milliseconds: state.positionMs);
    final duration = Duration(milliseconds: state.durationMs);
    final progress = state.durationMs > 0
        ? (state.positionMs / state.durationMs).clamp(0.0, 1.0)
        : 0.0;
    final enabled = state.currentSong != null && state.durationMs > 0;

    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(formatDuration(position),
              textAlign: TextAlign.right,
              style: AppType.mono.copyWith(fontSize: 10.5)),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: Colors.white,
              inactiveTrackColor: const Color(0x2EFFFFFF),
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              value: progress.toDouble(),
              onChanged: enabled
                  ? (f) => controller.seekTo((state.durationMs * f).round())
                  : null,
            ),
          ),
        ),
        SizedBox(
          width: 42,
          child: Text(formatDuration(duration),
              style: AppType.mono.copyWith(fontSize: 10.5)),
        ),
      ],
    );
  }
}

/// A small icon button with a hover highlight; dims when disabled.
class _IconBtn extends StatefulWidget {
  final String icon;
  final String tooltip;
  final double size;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 20,
    this.color = AppColors.textSecondary,
    this.enabled = true,
  });

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.enabled
        ? (_hover ? AppColors.textPrimary : widget.color)
        : AppColors.textDisabled;
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? widget.onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: AppIcon(widget.icon, size: widget.size, color: color),
          ),
        ),
      ),
    );
  }
}

/// Volume icon + slider, wired to the engine via [PlaybackController.setVolume].
class _VolumeControl extends ConsumerStatefulWidget {
  const _VolumeControl();

  @override
  ConsumerState<_VolumeControl> createState() => _VolumeControlState();
}

class _VolumeControlState extends ConsumerState<_VolumeControl> {
  double _volume = 1.0;
  double _lastNonZero = 1.0;

  void _set(double v) {
    setState(() => _volume = v);
    ref.read(playbackControllerProvider).setVolume(v);
  }

  void _toggleMute() {
    if (_volume > 0) {
      _lastNonZero = _volume;
      _set(0);
    } else {
      _set(_lastNonZero == 0 ? 1.0 : _lastNonZero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleMute,
            child: Icon(
              _volume == 0
                  ? Icons.volume_off_rounded
                  : (_volume < 0.5
                      ? Icons.volume_down_rounded
                      : Icons.volume_up_rounded),
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(
          width: 96,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: Colors.white,
              inactiveTrackColor: const Color(0x2EFFFFFF),
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(value: _volume, onChanged: _set),
          ),
        ),
      ],
    );
  }
}
