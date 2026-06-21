import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Renders cover art from a source that may be a bundled asset path
/// (`assets/...`), a network URL (`http...`), or null/empty. Falls back to a
/// neutral placeholder while loading or on error, so the same widget works for
/// both mock (asset) and real (Supabase/catalog network) songs.
class CoverImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double iconSize;

  const CoverImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final u = url;
    if (u == null || u.isEmpty) return _placeholder();
    if (u.startsWith('assets')) {
      return Image.asset(u,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, _, _) => _placeholder());
    }
    if (u.startsWith('http')) {
      return Image.network(
        u,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _placeholder(),
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: AppColors.surfaceHigh,
        alignment: Alignment.center,
        child: Icon(Icons.music_note_rounded,
            size: iconSize, color: AppColors.textTertiary),
      );
}
