import '../../core/result.dart';
import '../models/broadcast.dart';
import '../models/remote_config.dart';
import '../models/user.dart';

/// Authentication, account management, and server config/broadcast checks.
/// Ported from Kotlin `domain.repository.AuthRepository`.
abstract class AuthRepository {
  Future<Result<Unit>> signUp(String username, String email, String password);
  Future<Result<Unit>> signIn(String email, String password);
  Future<Result<Unit>> signOut();
  Future<Result<Unit>> resetPassword(String email);
  Future<Result<Unit>> resendVerificationEmail(String email);
  Future<bool> isEmailVerified();

  Future<Result<Unit>> updateDisplayName(String name);
  Future<Result<Unit>> updateUsername(String name);
  Future<Result<Unit>> updateAvatar(String url);
  Future<Result<Unit>> deleteAccount();

  Future<User?> refreshUser();
  Stream<bool> isAuthenticated();
  Stream<User?> getCurrentUser();
  Future<String?> getCurrentUserId();
  Future<String?> getCurrentUserEmail();
  Future<String?> getCurrentAccessToken();

  Future<Broadcast?> fetchLatestActiveBroadcast();
  Future<RemoteConfig?> checkRemoteConfig();
}
