/// Subscription tiers. Ported from Kotlin `SubscriptionPlan`.
enum SubscriptionPlan {
  free,
  premiumIndividual,
  premiumFamily,
  student,
}

/// An authenticated user. Ported from Kotlin `domain.model.User`.
class User {
  final String id;
  final String email;
  final String? username;
  final String? displayName;
  final String? avatarUrl;
  final SubscriptionPlan plan;
  final int createdAt;

  const User({
    required this.id,
    required this.email,
    this.username,
    this.displayName,
    this.avatarUrl,
    this.plan = SubscriptionPlan.free,
    required this.createdAt,
  });

  /// True for any non-free tier.
  bool get isPremium => plan != SubscriptionPlan.free;

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? avatarUrl,
    SubscriptionPlan? plan,
    int? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
