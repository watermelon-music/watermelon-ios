import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/auth_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/square_icon_button.dart';

/// Screen 03 — Register, with a live password-strength meter and a Terms
/// checkbox.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _password = 'watermelon';
  bool _agreed = true;

  /// 0–4 strength score: length, letters+digits, symbol, length ≥ 10.
  int get _strength {
    final p = _password;
    if (p.isEmpty) return 0;
    var score = 0;
    if (p.length >= 6) score++;
    if (RegExp(r'[A-Za-z]').hasMatch(p) && RegExp(r'\d').hasMatch(p)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score++;
    if (p.length >= 10) score++;
    return score.clamp(0, 4);
  }

  String get _strengthLabel {
    switch (_strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Okay';
      case 3:
        return 'Good';
      default:
        return 'Strong';
    }
  }

  Color get _strengthColor =>
      _strength >= 4 ? AppColors.rindGreen : (_strength >= 2 ? AppColors.accentOrange : AppColors.primary);

  @override
  Widget build(BuildContext context) {
    final canSubmit = _agreed;
    return Scaffold(
      body: Stack(
        children: [
          // Green glow behind the header (register uses the rind-green accent).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x294CAF50), Color(0x00000000)],
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
                    onTap: () => context.go('/login'),
                  ),
                  const SizedBox(height: 30),
                  Text('Create your account', style: AppType.h1),
                  const SizedBox(height: 6),
                  Text('Join free. Upgrade to Premium anytime.',
                      style: AppType.bodySm.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 26),
                  const AuthField(label: 'Name', initialValue: 'Avery Melon'),
                  const SizedBox(height: AppSpacing.md),
                  const AuthField(
                    label: 'Email',
                    initialValue: 'avery@watermelon.fm',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AuthField(
                    label: 'Password',
                    initialValue: _password,
                    obscure: true,
                    onChanged: (v) => setState(() => _password = v),
                  ),
                  const SizedBox(height: 12),
                  _StrengthMeter(score: _strength, label: _strengthLabel, color: _strengthColor),
                  const SizedBox(height: 22),
                  _TermsRow(
                    agreed: _agreed,
                    onToggle: () => setState(() => _agreed = !_agreed),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton('Create account',
                      onPressed: canSubmit ? () => context.go('/home') : null),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text.rich(TextSpan(
                        text: 'Already have an account? ',
                        style: AppType.bodySm.copyWith(color: AppColors.textSecondary),
                        children: [
                          TextSpan(
                              text: 'Log in',
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

class _StrengthMeter extends StatelessWidget {
  final int score;
  final String label;
  final Color color;
  const _StrengthMeter({required this.score, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 4; i++)
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: i < score ? color : const Color(0x1FFFFFFF),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        const SizedBox(width: 10),
        Text(label,
            style: AppType.caption.copyWith(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _TermsRow extends StatelessWidget {
  final bool agreed;
  final VoidCallback onToggle;
  const _TermsRow({required this.agreed, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onToggle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: agreed ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(7),
              border: agreed ? null : Border.all(color: AppColors.textTertiary, width: 1.5),
            ),
            child: agreed
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text.rich(TextSpan(
              text: "I agree to Watermelon's ",
              style: AppType.bodySm.copyWith(color: AppColors.textSecondary, fontSize: 13),
              children: [
                TextSpan(text: 'Terms', style: AppType.label.copyWith(fontSize: 13)),
                const TextSpan(text: ' and '),
                TextSpan(text: 'Privacy Policy', style: AppType.label.copyWith(fontSize: 13)),
                const TextSpan(text: '.'),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
