import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/primary_button.dart';

/// Screen 01 — Onboarding. Full-bleed field hero with the gradient wordmark and
/// the "Feel the juice." display headline.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bgFieldTall, fit: BoxFit.cover),
          // Scrim: clear at the top, fading to solid bg at the bottom.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x73000000), Color(0x0D000000), Color(0x9E050505), AppColors.bg],
                stops: [0.0, 0.30, 0.64, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                // Logo + wordmark.
                Column(
                  children: [
                    Image.asset(AppAssets.logoSlice, width: 46, height: 46),
                    const SizedBox(height: 10),
                    Text('WATERMELON',
                        style: AppType.label.copyWith(
                            letterSpacing: 3,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withValues(alpha: 0.92))),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Open-source music'.toUpperCase(),
                          style: AppType.overline.copyWith(
                              color: AppColors.primaryBright, letterSpacing: 2)),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Feel the', style: AppType.displayLg),
                      ShaderMask(
                        shaderCallback: (b) => const LinearGradient(
                          begin: Alignment(-0.7, -1),
                          end: Alignment(0.7, 1),
                          colors: [AppColors.primary, AppColors.accentOrange],
                        ).createShader(b),
                        child: Text('juice.',
                            style: AppType.displayLg.copyWith(color: Colors.white)),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Text(
                          'Millions of tracks, hi-fi sound and live radio. '
                          'No ads, no lock-in — just press play.',
                          style: AppType.body.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton("Get started — it's free",
                          onPressed: () => context.go('/login')),
                      const SizedBox(height: AppSpacing.lg),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.go('/login'),
                          child: Text.rich(TextSpan(
                            text: 'Already have an account? ',
                            style: AppType.bodySm.copyWith(color: AppColors.textSecondary),
                            children: [
                              TextSpan(
                                  text: 'Log in',
                                  style: AppType.label.copyWith(color: AppColors.textPrimary)),
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const _PageDots(count: 3, active: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int count;
  final int active;
  const _PageDots({required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.5),
            width: i == active ? 26 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? AppColors.primary : const Color(0x4DFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
      ],
    );
  }
}
