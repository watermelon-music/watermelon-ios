/// A subscription plan (Subscription screen). Prices switch between monthly
/// and annual via the billing toggle.
class Plan {
  final String id;
  final String name;
  final String subtitle;
  final String monthlyPrice; // e.g. "$9.99"
  final String annualPrice; // e.g. "$95.90"
  final bool featured; // shows the "MOST POPULAR" badge

  const Plan({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.monthlyPrice,
    required this.annualPrice,
    this.featured = false,
  });
}
