import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/result.dart';
import '../../domain/models/broadcast.dart';
import '../../domain/models/remote_config.dart' as domain;
import '../../domain/models/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';
import '../remote/supabase/supabase_mappers.dart';

/// [AuthRepository] backed by Supabase (GoTrue auth + Postgrest tables).
/// Thin SDK adapter (parsing/validation live in pure helpers that are tested
/// separately). See LOGIC_IMPLEMENTATION.md §4.9.
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;
  const AuthRepositoryImpl(this._client);

  GoTrueClient get _auth => _client.auth;

  @override
  Future<Result<Unit>> signUp(
          String username, String email, String password) =>
      Result.guard(() async {
        final res = await _auth.signUp(
          email: email,
          password: password,
          data: {'username': username},
        );
        final uid = res.user?.id;
        if (uid != null) {
          try {
            await _client.from('profiles').upsert({
              'id': uid,
              'email': email,
              'username': username,
            });
          } catch (_) {
            // A DB trigger may already create the profile row.
          }
        }
        return Unit.unit;
      });

  @override
  Future<Result<Unit>> signIn(String email, String password) =>
      Result.guard(() async {
        await _auth.signInWithPassword(email: email, password: password);
        return Unit.unit;
      });

  @override
  Future<Result<Unit>> signOut() => Result.guard(() async {
        await _auth.signOut();
        return Unit.unit;
      });

  @override
  Future<Result<Unit>> resetPassword(String email) => Result.guard(() async {
        await _auth.resetPasswordForEmail(email);
        return Unit.unit;
      });

  @override
  Future<Result<Unit>> resendVerificationEmail(String email) =>
      Result.guard(() async {
        await _auth.resend(type: OtpType.signup, email: email);
        return Unit.unit;
      });

  @override
  Future<bool> isEmailVerified() async {
    try {
      await _auth.refreshSession();
    } catch (_) {}
    return _auth.currentUser?.emailConfirmedAt != null;
  }

  @override
  Future<Result<Unit>> updateDisplayName(String name) =>
      _updateProfile({'display_name': name});

  @override
  Future<Result<Unit>> updateUsername(String name) =>
      _updateProfile({'username': name});

  @override
  Future<Result<Unit>> updateAvatar(String url) =>
      _updateProfile({'avatar_url': url});

  Future<Result<Unit>> _updateProfile(Map<String, dynamic> changes) =>
      Result.guard(() async {
        final uid = _auth.currentUser?.id;
        if (uid == null) throw StateError('Not signed in');
        await _client.from('profiles').update(changes).eq('id', uid);
        await _auth.updateUser(UserAttributes(data: changes));
        return Unit.unit;
      });

  @override
  Future<Result<Unit>> deleteAccount() => Result.guard(() async {
        try {
          await _client.rpc('delete_user');
        } catch (_) {
          // RPC may not exist on every backend; sign out regardless.
        }
        await _auth.signOut();
        return Unit.unit;
      });

  @override
  Future<domain.User?> refreshUser() async {
    try {
      await _auth.refreshSession();
    } catch (_) {}
    return _fetchProfile();
  }

  @override
  Stream<bool> isAuthenticated() async* {
    yield _auth.currentSession != null;
    yield* _auth.onAuthStateChange.map((s) => s.session != null);
  }

  @override
  Stream<domain.User?> getCurrentUser() async* {
    yield await _fetchProfile();
    await for (final _ in _auth.onAuthStateChange) {
      yield await _fetchProfile();
    }
  }

  @override
  Future<String?> getCurrentUserId() async => _auth.currentUser?.id;

  @override
  Future<String?> getCurrentUserEmail() async => _auth.currentUser?.email;

  @override
  Future<String?> getCurrentAccessToken() async =>
      _auth.currentSession?.accessToken;

  @override
  Future<Broadcast?> fetchLatestActiveBroadcast() async {
    try {
      final row = await _client
          .from('broadcasts')
          .select()
          .eq('active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return row == null ? null : broadcastFromRow(row);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<domain.RemoteConfig?> checkRemoteConfig() async {
    try {
      final row =
          await _client.from('remote_config').select().limit(1).maybeSingle();
      return row == null ? null : remoteConfigFromRow(row);
    } catch (_) {
      return null;
    }
  }

  Future<domain.User?> _fetchProfile() async {
    final authUser = _auth.currentUser;
    if (authUser == null) return null;
    try {
      final row = await _client
          .from('profiles')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();
      if (row != null) return profileRowToUser(row);
    } catch (_) {}
    // Fallback to auth metadata if the profile row isn't readable yet.
    return domain.User(
      id: authUser.id,
      email: authUser.email ?? '',
      createdAt: parseTimestamp(authUser.createdAt),
    );
  }
}
