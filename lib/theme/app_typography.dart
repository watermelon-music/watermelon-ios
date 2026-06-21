import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Watermelon Dark — type scale.
///
/// Display / UI font:  **Inter**          (weights 400–900)
/// Numeric / timecodes: **JetBrains Mono** (weights 400–500)
///
/// Fonts are loaded at runtime via the `google_fonts` package, so no .ttf files
/// are bundled. The styles are `static final` (not `const`) because each is
/// produced by a GoogleFonts factory.
class AppType {
  AppType._();

  /// Registered family names (after the first GoogleFonts call resolves them).
  static String get fontFamily => GoogleFonts.inter().fontFamily!;
  static String get monoFamily => GoogleFonts.jetBrainsMono().fontFamily!;

  static TextStyle _inter({
    required double size,
    required FontWeight weight,
    double? height,
    double? spacing,
    Color color = AppColors.textPrimary,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: spacing,
        color: color,
      );

  static TextStyle _mono({
    required double size,
    required FontWeight weight,
    Color color = AppColors.textTertiary,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  // Display
  static final TextStyle displayLg =
      _inter(size: 56, height: 0.98, weight: FontWeight.w800, spacing: -2.5);
  static final TextStyle display =
      _inter(size: 40, height: 0.98, weight: FontWeight.w800, spacing: -1.6);

  // Headings
  static final TextStyle h1 =
      _inter(size: 30, height: 1.1, weight: FontWeight.w700, spacing: -1.0);
  static final TextStyle h2 =
      _inter(size: 24, height: 1.1, weight: FontWeight.w800, spacing: -0.6);
  static final TextStyle title =
      _inter(size: 19, height: 1.0, weight: FontWeight.w800, spacing: -0.4);
  static final TextStyle sectionTitle =
      _inter(size: 16, weight: FontWeight.w800);

  // Body
  static final TextStyle body =
      _inter(size: 16, height: 1.5, weight: FontWeight.w400);
  static final TextStyle bodySm = _inter(
      size: 14, height: 1.45, weight: FontWeight.w400, color: AppColors.textSecondary);

  // Supporting
  static final TextStyle label = _inter(size: 13, weight: FontWeight.w600);
  static final TextStyle caption =
      _inter(size: 12, weight: FontWeight.w500, color: AppColors.textSecondary);

  /// Use with `Text(..., style: AppType.overline)` and uppercase the string.
  static final TextStyle overline = _inter(
      size: 12, weight: FontWeight.w600, spacing: 1.5, color: AppColors.textTertiary);

  /// Timecodes, durations, track numbers.
  static final TextStyle mono = _mono(size: 12, weight: FontWeight.w500);
}
