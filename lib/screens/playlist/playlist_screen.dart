import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/playlist.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../state/player_controller.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/like_button.dart';
import '../../widgets/mini_player.dart';
import '../../widgets/pressable.dart';
import '../../widgets/track_tile.dart';

/// Screen 08 — Playlist detail.
class PlaylistScreen extends ConsumerWidget {
  final String id;
  const PlaylistScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlist = MockData.playlistById(id);
    final likeKey = 'playlist:${playlist.id}';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0506),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _Hero(playlist: playlist)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPad, 0, AppSpacing.screenPad, 158),
                sliver: SliverList.list(children: [
                  Transform.translate(
                    offset: const Offset(0, -6),
                    child: _ActionRow(
                      likeKey: likeKey,
                      onPlay: () {
                        ref.read(playerProvider.notifier).play(
                              playlist.tracks.first,
                              queue: playlist.tracks,
                            );
                        context.push('/player');
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  for (var i = 0; i < playlist.tracks.length; i++)
                    TrackTile(
                      track: playlist.tracks[i],
                      index: i + 1,
                      queue: playlist.tracks,
                    ),
                ]),
              ),
            ],
          ),
          // Pinned back / more over the hero.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPad),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  const AppIcon(AppAssets.moreHoriz, size: 22),
                ],
              ),
            ),
          ),
          // Mini-player (no tab bar — this route sits above the shell).
          const Positioned(
            left: 8,
            right: 8,
            bottom: 12,
            child: SafeArea(top: false, child: MiniPlayer()),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final Playlist playlist;
  const _Hero({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(playlist.cover, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x59000000), Color(0x330A0506), Color(0xEB0A0506), Color(0xFF0A0506)],
                stops: [0.0, 0.38, 0.86, 1.0],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.screenPad,
            right: AppSpacing.screenPad,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Playlist'.toUpperCase(),
                    style: AppType.overline.copyWith(
                        color: const Color(0xFFFF8A8A), letterSpacing: 1.6)),
                const SizedBox(height: 8),
                Text(playlist.title,
                    style: AppType.display.copyWith(fontSize: 40, height: 0.98)),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(playlist.description,
                      style: AppType.bodySm.copyWith(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(playlist.ownerAvatar, width: 22, height: 22, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 8),
                    Text(playlist.owner,
                        style: AppType.label.copyWith(fontSize: 13)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '· ${_formatSaves(playlist.saves)} saves · ${playlist.totalDuration}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.caption.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatSaves(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _ActionRow extends StatelessWidget {
  final String likeKey;
  final VoidCallback onPlay;
  const _ActionRow({required this.likeKey, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            LikeButton(id: likeKey, size: 27, inactiveColor: AppColors.textSecondary),
            const SizedBox(width: 22),
            const AppIcon(AppAssets.download, size: 25, color: AppColors.textSecondary),
            const SizedBox(width: 22),
            const AppIcon(AppAssets.share, size: 25, color: AppColors.textSecondary),
          ],
        ),
        Pressable(
          onTap: onPlay,
          child: Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [BoxShadow(color: Color(0x80FF1A1A), blurRadius: 26, offset: Offset(0, 10))],
            ),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0x73000000),
        ),
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }
}
