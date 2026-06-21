import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';

/// Subscription screen state: billing period + selected plan.
class SubscriptionState {
  final bool annual;
  final String selectedPlanId;

  const SubscriptionState({
    this.annual = false,
    this.selectedPlanId = 'individual',
  });

  SubscriptionState copyWith({bool? annual, String? selectedPlanId}) {
    return SubscriptionState(
      annual: annual ?? this.annual,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
    );
  }
}

class SubscriptionController extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() => const SubscriptionState();

  void setAnnual(bool annual) => state = state.copyWith(annual: annual);
  void selectPlan(String id) => state = state.copyWith(selectedPlanId: id);

  /// Footer fineprint that switches with the billing period.
  String get fineprint => state.annual
      ? 'Billed annually after your free trial.'
      : 'Billed monthly after your free trial.';

  /// Price label for a plan under the current billing period.
  String priceFor(String planId) {
    final plan = MockData.plans.firstWhere((p) => p.id == planId);
    return state.annual ? plan.annualPrice : plan.monthlyPrice;
  }
}

final subscriptionProvider =
    NotifierProvider<SubscriptionController, SubscriptionState>(
        SubscriptionController.new);
