import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/plan.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../state/subscription_provider.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/primary_button.dart';

/// Screen 10 — Subscription (Watermelon Premium). Pushed full-screen over the
/// shell; billing period + selected plan live in [subscriptionProvider].
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    final controller = ref.read(subscriptionProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Faint tiled texture across the top.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(AppAssets.patternSlices, fit: BoxFit.cover),
            ),
          ),
          // Red glow wash.
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 340,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x38FF1A1A), Color(0x00000000)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: AppIcon(AppAssets.close,
                          size: 22, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const _Header(),
                const SizedBox(height: 22),
                _BillingToggle(
                  annual: sub.annual,
                  onMonthly: () => controller.setAnnual(false),
                  onAnnual: () => controller.setAnnual(true),
                ),
                const SizedBox(height: 18),
                for (final plan in MockData.plans) ...[
                  _PlanCard(
                    plan: plan,
                    selected: sub.selectedPlanId == plan.id,
                    price: controller.priceFor(plan.id),
                    annual: sub.annual,
                    onTap: () => controller.selectPlan(plan.id),
                  ),
                  if (plan != MockData.plans.last) const SizedBox(height: 12),
                ],
                const SizedBox(height: 22),
                for (final perk in MockData.perks) ...[
                  _PerkRow(perk),
                  if (perk != MockData.perks.last) const SizedBox(height: 13),
                ],
                const SizedBox(height: 24),
                PrimaryButton('Start 1-month free trial', onPressed: () {}),
                const SizedBox(height: 14),
                Text('${controller.fineprint} Cancel anytime.',
                    textAlign: TextAlign.center,
                    style: AppType.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: AppColors.textDisabled)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppAssets.logoSlice, width: 50, height: 50, fit: BoxFit.contain),
        const SizedBox(height: 14),
        // "Watermelon Premium" — Premium in the brand red→orange gradient.
        Text.rich(
          TextSpan(
            text: 'Watermelon ',
            style: AppType.h2.copyWith(fontSize: 28, letterSpacing: -1),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primary, AppColors.accentOrange],
                  ).createShader(bounds),
                  child: Text('Premium',
                      style: AppType.h2.copyWith(
                          fontSize: 28, letterSpacing: -1, color: Colors.white)),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            'Ad-free listening, offline downloads and lossless hi-fi audio.',
            textAlign: TextAlign.center,
            style: AppType.body.copyWith(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _BillingToggle extends StatelessWidget {
  final bool annual;
  final VoidCallback onMonthly;
  final VoidCallback onAnnual;
  const _BillingToggle({
    required this.annual,
    required this.onMonthly,
    required this.onAnnual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0x12FFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          Expanded(child: _Segment('Monthly', selected: !annual, onTap: onMonthly)),
          Expanded(child: _Segment('Annual · save 20%', selected: annual, onTap: onAnnual)),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Segment(this.label, {required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(label,
            style: AppType.label.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.black : AppColors.textSecondary)),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Plan plan;
  final bool selected;
  final String price;
  final bool annual;
  final VoidCallback onTap;
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.price,
    required this.annual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        decoration: BoxDecoration(
          color: selected ? const Color(0x1AFF1A1A) : const Color(0x0DFFFFFF),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0x1AFFFFFF),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                _RadioDot(selected: selected),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name,
                          style: AppType.label.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(plan.subtitle, style: AppType.caption),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(price,
                        style: AppType.h2.copyWith(fontSize: 19, letterSpacing: 0)),
                    const SizedBox(height: 4),
                    Text(annual ? 'per year' : 'per month',
                        style: AppType.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ],
            ),
            if (plan.featured)
              Positioned(
                top: -26,
                left: 0,
                child: Container(
                  height: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text('MOST POPULAR',
                      style: AppType.label.copyWith(
                          fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 23,
      height: 23,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : const Color(0x59FFFFFF),
          width: 2,
        ),
      ),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.primary : Colors.transparent,
        ),
      ),
    );
  }
}

class _PerkRow extends StatelessWidget {
  final String perk;
  const _PerkRow(this.perk);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x29FF1A1A),
          ),
          child: const AppIcon(AppAssets.check, size: 13, color: AppColors.primaryBright),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(perk,
              style: AppType.bodySm.copyWith(
                  fontSize: 14, height: 1.3, color: const Color(0xD9FFFFFF))),
        ),
      ],
    );
  }
}
