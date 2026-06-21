import 'package:flutter/material.dart';

import '../models/category.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// "Browse all" tile (Search): a colored card with the label top-left and a
/// rotated artwork thumbnail tucked into the bottom-right corner.
class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryCard(this.category, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          height: 96,
          color: category.color,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                left: 14,
                top: 14,
                right: 56,
                child: Text(
                  category.label,
                  style: AppType.sectionTitle.copyWith(fontSize: 15),
                ),
              ),
              Positioned(
                right: -12,
                bottom: -10,
                child: Transform.rotate(
                  angle: 25 * 3.1415926535 / 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(category.image,
                        width: 62, height: 62, fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
