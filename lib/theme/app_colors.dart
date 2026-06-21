import 'package:flutter/material.dart';

/// Watermelon Dark — color tokens.
///
/// Dark-first palette: a pure-black canvas, near-black surfaces, and a single
/// vivid red brand accent (`primary`) reserved for the most important action
/// (CTAs, now-playing, active states). Use red sparingly.
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFFF1A1A); // brand red — primary CTA / now-playing
  static const Color primaryBright = Color(0xFFFF5252); // secondary accent / links
  static const Color accentOrange = Color(0xFFFF6A3D); // brand-gradient partner
  static const Color rindGreen = Color(0xFF4CAF50); // success / password-strong

  // ── Player "wine" gradient ────────────────────────────────────────────
  static const Color wineDeep = Color(0xFF7A1020);
  static const Color wineMid = Color(0xFF3A0A12);

  // ── Neutrals (dark-first) ─────────────────────────────────────────────
  static const Color black = Color(0xFF000000); // device canvas
  static const Color bg = Color(0xFF050505); // app/scaffold background
  static const Color surface = Color(0xFF0C0C0D); // raised background
  static const Color surfaceHigh = Color(0xFF1A1A1A); // cards, inputs, sheets
  static const Color surfaceGlass = Color(0xD11C1212); // frosted mini-player (~82% alpha)

  // ── Text / on-colors (white at varying opacity) ───────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0x99FFFFFF); // 60%
  static const Color textTertiary = Color(0x70FFFFFF); // ~44%
  static const Color textDisabled = Color(0x52FFFFFF); // 32%

  // ── Hairlines & subtle fills ──────────────────────────────────────────
  static const Color border = Color(0x1AFFFFFF); // 10% — 1px strokes
  static const Color fillSubtle = Color(0x12FFFFFF); // 7%  — chip / tile backgrounds

  // ── Gradients ─────────────────────────────────────────────────────────
  /// Hero / Premium gradient (red → orange).
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment(-0.7, -1.0),
    end: Alignment(0.7, 1.0),
    colors: [primary, accentOrange],
  );

  /// Now-playing background (deep wine → near-black).
  static const LinearGradient playerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [wineDeep, wineMid, Color(0xFF0A0506)],
    stops: [0.0, 0.42, 1.0],
  );

  /// Soft top "glow" behind headers on Home / Profile.
  static const LinearGradient headerGlow = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x8C7A1020), Color(0x00000000)],
  );
}
