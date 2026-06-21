import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/song.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../state/repository_providers.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/category_card.dart';
import '../../widgets/cover_image.dart';
import '../../widgets/download_button.dart';
import '../../widgets/section_header.dart';
import '../../data/mock_data.dart';

const double _kBottomInset = 158;

/// Screen 05 — Search. Live YouTube search (debounced); tap a result to play,
/// or download it for offline.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    // 300ms debounce (matches the Kotlin SearchViewModel).
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final searching = _query.isNotEmpty;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPad, AppSpacing.sm, AppSpacing.screenPad, _kBottomInset),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 16),
              child: Text('Search', style: AppType.h2.copyWith(fontSize: 28)),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: AppDecoration.input,
              child: Row(
                children: [
                  const AppIcon(AppAssets.search, size: 19, color: AppColors.textTertiary),
                  const SizedBox(width: 11),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: _onChanged,
                      textInputAction: TextInputAction.search,
                      cursorColor: AppColors.primary,
                      style: AppType.body.copyWith(fontSize: 15),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        filled: false,
                        hintText: 'Songs, artists on YouTube',
                        hintStyle: AppType.body
                            .copyWith(fontSize: 15, color: AppColors.textTertiary),
                      ),
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _controller.clear();
                        _debounce?.cancel();
                        setState(() => _query = '');
                      },
                      child: const Icon(Icons.close_rounded,
                          size: 18, color: AppColors.textTertiary),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            if (searching) _Results(query: _query) else _Browse(),
          ],
        ),
      ),
    );
  }
}

/// Live results for the current query.
class _Results extends ConsumerWidget {
  final String query;
  const _Results({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider(query));
    return results.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (_, _) => _message('Search failed — check your connection'),
      data: (songs) {
        if (songs.isEmpty) return _message('No results for “$query”');
        return Column(
          children: [
            for (var i = 0; i < songs.length; i++)
              _SongRow(song: songs[i], queue: songs, index: i),
          ],
        );
      },
    );
  }

  Widget _message(String text) => Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Text(text,
              style: AppType.bodySm.copyWith(color: AppColors.textSecondary)),
        ),
      );
}

/// A single search result: tap to play (with the result list as the queue),
/// plus a download control on the right.
class _SongRow extends ConsumerWidget {
  final Song song;
  final List<Song> queue;
  final int index;
  const _SongRow({required this.song, required this.queue, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrent = ref.watch(
        playbackStateProvider.select((s) => s.currentSong?.id == song.id));
    return InkWell(
      onTap: () =>
          ref.read(playbackControllerProvider).playQueue(queue, startIndex: index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: CoverImage(song.coverUrl, width: 50, height: 50),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.label.copyWith(
                        fontSize: 14.5,
                        color: isCurrent
                            ? AppColors.primaryBright
                            : AppColors.textPrimary,
                      )),
                  const SizedBox(height: 3),
                  Text(song.artistName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.caption),
                ],
              ),
            ),
            const SizedBox(width: 10),
            DownloadButton(song, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Default state (no query): the "Browse all" category grid.
class _Browse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = MockData.categories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Browse all'),
        const SizedBox(height: 14),
        for (var i = 0; i < items.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(child: CategoryCard(items[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < items.length
                      ? CategoryCard(items[i + 1])
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
