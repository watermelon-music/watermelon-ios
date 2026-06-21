import 'dart:ui';

/// A "Browse all" category tile (Search screen) — a colored card with a
/// rotated artwork thumbnail.
class Category {
  final String label;
  final Color color;
  final String image;

  const Category({
    required this.label,
    required this.color,
    required this.image,
  });
}
