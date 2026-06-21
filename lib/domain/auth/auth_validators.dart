import '../../config/app_constants.dart';

/// Pure auth validation + password-strength helpers (ported from the Kotlin
/// AuthViewModel — see LOGIC_IMPLEMENTATION.md §9). UI-independent and tested.
class AuthValidators {
  AuthValidators._();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValidEmail(String email) => _emailRegex.hasMatch(email.trim());

  static bool isValidPassword(String password) =>
      password.length >= AppConstants.passwordMinLength;

  static String? emailError(String email) =>
      isValidEmail(email) ? null : 'Enter a valid email address';

  static String? passwordError(String password) => isValidPassword(password)
      ? null
      : 'Password must be at least ${AppConstants.passwordMinLength} characters';

  /// Password strength as a 0–4 score (drives the 4-bar meter).
  static int passwordStrength(String password) {
    if (password.isEmpty) return 0;
    var score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[A-Z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    return score;
  }

  static const List<String> _strengthLabels = [
    'Too weak',
    'Weak',
    'Fair',
    'Good',
    'Strong',
  ];

  static String passwordStrengthLabel(int score) =>
      _strengthLabels[score.clamp(0, 4)];
}

/// Map a thrown auth error to a user-facing message (ported from the Kotlin
/// AuthViewModel error mapping).
String authErrorMessage(Object error) {
  final msg = error.toString().toLowerCase();
  if (msg.contains('rate limit') || msg.contains('429')) {
    return 'Too many attempts. Please wait a moment and try again.';
  }
  if (msg.contains('invalid login') ||
      msg.contains('invalid credentials') ||
      msg.contains('invalid email or password')) {
    return 'Incorrect email or password.';
  }
  if (msg.contains('already registered') ||
      msg.contains('already exists') ||
      msg.contains('user already')) {
    return 'An account with this email already exists.';
  }
  if (msg.contains('not confirmed') || msg.contains('email not verified')) {
    return 'Please verify your email before signing in.';
  }
  if (msg.contains('weak password') || msg.contains('password should be')) {
    return 'Password is too weak.';
  }
  if (msg.contains('network') ||
      msg.contains('socket') ||
      msg.contains('timeout') ||
      msg.contains('connection')) {
    return 'Network error. Check your connection and try again.';
  }
  return 'Something went wrong. Please try again.';
}
