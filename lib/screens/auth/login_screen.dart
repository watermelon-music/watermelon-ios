import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/auth_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/social_button.dart';
import '../../widgets/square_icon_button.dart';

/// Screen 02 — Log in.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Tiled slice pattern + red glow behind the header.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Opacity(
              opacity: 0.10,
              child: Image.asset(AppAssets.patternSlices, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 340,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x29FF1A1A), Color(0x00000000)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, AppSpacing.lg, 28, AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SquareIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.go('/onboarding'),
                  ),
                  const SizedBox(height: 30),
                  Image.asset(AppAssets.logoSlice, width: 44, height: 44),
                  const SizedBox(height: 22),
                  Text('Welcome back', style: AppType.h1),
                  const SizedBox(height: 6),
                  Text('Log in to pick up where the music left off.',
                      style: AppType.bodySm.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 30),
                  const AuthField(
                    label: 'Email',
                    iconAsset: AppAssets.mail,
                    initialValue: 'avery@watermelon.fm',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const AuthField(
                    label: 'Password',
                    iconAsset: AppAssets.lock,
                    initialValue: 'watermelon',
                    obscure: true,
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Forgot password?',
                        style: AppType.label.copyWith(color: AppColors.primaryBright)),
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton('Log in', onPressed: () => context.go('/home')),
                  const SizedBox(height: AppSpacing.xl),
                  const _OrDivider(),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      Expanded(
                        child: SocialButton(
                          icon: const Icon(Icons.apple, color: Colors.white, size: 22),
                          label: 'Apple',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: SocialButton(
                          icon: const _GoogleG(),
                          label: 'Google',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go('/register'),
                      child: Text.rich(TextSpan(
                        text: 'New to Watermelon? ',
                        style: AppType.bodySm.copyWith(color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                              text: 'Create account',
                              style: AppType.label.copyWith(color: AppColors.primaryBright)),
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('or continue with',
              style: AppType.caption.copyWith(color: AppColors.textTertiary)),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

/// A simple multi-color "G" stand-in for the Google logo (no asset bundled).
class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) {
    return Text('G',
        style: AppType.title.copyWith(
            fontSize: 18, color: const Color(0xFF4285F4), fontWeight: FontWeight.w800));
  }
}
