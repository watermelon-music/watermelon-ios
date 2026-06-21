import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Spacing scale (logical px). Screens use [screenPad] for horizontal gutters.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 18;
  static const double xl = 24;
  static const double xxl = 32;

  static const double screenPad = 18; // default horizontal screen gutter
}

/// Corner radii.
class AppRadius {
  AppRadius._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 14; // inputs, chips
  static const double card = 16; // cards, plan rows
  static const double xl = 18; // feature cards, artwork
  static const double pill = 9999; // buttons, chips, toggles
  static const double sheet = 46; // bottom-sheet / device corner

  static BorderRadius all(double r) => BorderRadius.circular(r);
}

/// Reusable shadows.
class AppShadow {
  AppShadow._();

  /// Red glow under the primary button / FAB.
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(color: Color(0x6BFF1A1A), blurRadius: 30, offset: Offset(0, 12)),
  ];

  /// Lift for the floating mini-player.
  static const List<BoxShadow> floating = [
    BoxShadow(color: Color(0x80000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  /// Album-art / artwork drop.
  static const List<BoxShadow> artwork = [
    BoxShadow(color: Color(0x80000000), blurRadius: 60, offset: Offset(0, 30)),
  ];
}

/// Motion.
class AppMotion {
  AppMotion._();
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 240);
  static const Curve curve = Curves.easeOutCubic;
}

/// Sizing constants pulled from the mockups.
class AppSize {
  AppSize._();
  static const double tabBarHeight = 88; // bottom nav (excl. safe-area)
  static const double miniPlayerHeight = 58;
  static const double buttonHeight = 56; // primary CTA
  static const double inputHeight = 54;
  static const double minTapTarget = 44; // never go below this
}

/// Convenience BoxDecorations.
class AppDecoration {
  AppDecoration._();

  static BoxDecoration card = BoxDecoration(
    color: AppColors.fillSubtle,
    borderRadius: BorderRadius.circular(AppRadius.card),
  );

  static BoxDecoration input = BoxDecoration(
    color: AppColors.surfaceHigh,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    border: Border.all(color: AppColors.border),
  );
}
