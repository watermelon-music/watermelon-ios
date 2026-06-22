import 'package:flutter/widgets.dart';

/// Responsive breakpoints. The app is mobile-first; at/above [desktop] width we
/// switch the shell chrome from the phone layout (bottom tab bar + floating
/// mini-player) to a desktop layout (left sidebar + persistent bottom transport
/// bar), à la Apple Music / Spotify. The content screens are reused as-is.
class AppBreakpoints {
  AppBreakpoints._();

  /// Width (logical px) at which the desktop layout takes over.
  static const double desktop = 900;

  /// Fixed sidebar width on desktop.
  static const double sidebarWidth = 248;

  /// Height of the persistent bottom transport bar on desktop.
  static const double playerBarHeight = 88;
}

extension ResponsiveContext on BuildContext {
  /// True when the window is wide enough for the desktop shell.
  bool get isDesktop =>
      MediaQuery.sizeOf(this).width >= AppBreakpoints.desktop;
}
