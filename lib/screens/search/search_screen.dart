import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/playlist.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/category_card.dart';
import '../../widgets/section_header.dart';

const double _kBottomInset = 158;

/// Screen 05 — Search.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<PlaylistRef> _recents = List.of(MockData.recents);

  @override
  Widget build(BuildContext context) {
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
            // Search field (presentational).
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
                      cursorColor: AppColors.primary,
                      style: AppType.body.copyWith(fontSize: 15),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        filled: false,
                        hintText: 'Artists, songs, podcasts',
                        hintStyle: AppType.body
                            .copyWith(fontSize: 15, color: AppColors.textTertiary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            if (_recents.isNotEmpty) ...[
              SectionHeader('Recent searches',
                  actionLabel: 'Clear', onAction: () => setState(_recents.clear)),
              const SizedBox(height: 12),
              for (final r in _recents) _RecentRow(r, onRemove: () => setState(() => _recents.remove(r))),
              const SizedBox(height: 24),
            ],
            const SectionHeader('Browse all'),
            const SizedBox(height: 14),
            _CategoryGrid(),
          ],
        ),
      ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  final PlaylistRef item;
  final VoidCallback onRemove;
  const _RecentRow(this.item, {required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(item.art, width: 50, height: 50, fit: BoxFit.cover),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.label.copyWith(fontSize: 14.5)),
                const SizedBox(height: 3),
                Text(item.subtitle, style: AppType.caption),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close_rounded, size: 16, color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = MockData.categories;
    return Column(
      children: [
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
