import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../state/likes_provider.dart';
import 'app_icon.dart';

/// A heart toggle bound to [likesProvider] for [id]. Toggling animates a quick
/// "pop" (scale bounce) so the like reads as a deliberate action everywhere it
/// appears (mini-player, track rows, playlist header, now-playing).
class LikeButton extends ConsumerStatefulWidget {
  final String id;
  final double size;

  /// Color when the track is **not** liked (liked is always brand red).
  final Color inactiveColor;
  final EdgeInsets padding;

  const LikeButton({
    super.key,
    required this.id,
    this.size = 24,
    this.inactiveColor = AppColors.textTertiary,
    this.padding = EdgeInsets.zero,
  });

  @override
  ConsumerState<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends ConsumerState<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 60),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    ref.read(likesProvider.notifier).toggle(widget.id);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final liked = ref.watch(isLikedProvider(widget.id));
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Padding(
        padding: widget.padding,
        child: ScaleTransition(
          scale: _scale,
          child: AppIcon(
            liked ? AppAssets.heartFilled : AppAssets.heart,
            size: widget.size,
            color: liked ? AppColors.primary : widget.inactiveColor,
          ),
        ),
      ),
    );
  }
}
