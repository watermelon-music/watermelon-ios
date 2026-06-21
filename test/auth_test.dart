import 'package:flutter_test/flutter_test.dart';
import 'package:watermelon/data/remote/supabase/supabase_mappers.dart';
import 'package:watermelon/domain/auth/auth_validators.dart';
import 'package:watermelon/domain/models/user.dart';

void main() {
  group('AuthValidators', () {
    test('email validation', () {
      expect(AuthValidators.isValidEmail('a@b.com'), isTrue);
      expect(AuthValidators.isValidEmail('avery@watermelon.fm'), isTrue);
      expect(AuthValidators.isValidEmail('nope'), isFalse);
      expect(AuthValidators.isValidEmail('a@b'), isFalse);
      expect(AuthValidators.isValidEmail('a b@c.com'), isFalse);
    });

    test('password requires the minimum length (6)', () {
      expect(AuthValidators.isValidPassword('12345'), isFalse);
      expect(AuthValidators.isValidPassword('123456'), isTrue);
      expect(AuthValidators.passwordError('123456'), isNull);
      expect(AuthValidators.passwordError('x'), isNotNull);
    });

    test('password strength scores 0..4 with labels', () {
      expect(AuthValidators.passwordStrength(''), 0);
      expect(AuthValidators.passwordStrength('abcdef'), 0); // short, lower only
      expect(AuthValidators.passwordStrength('Abcdefg1!'), 4); // all criteria
      expect(AuthValidators.passwordStrengthLabel(0), 'Too weak');
      expect(AuthValidators.passwordStrengthLabel(4), 'Strong');
      // label clamps out-of-range input
      expect(AuthValidators.passwordStrengthLabel(9), 'Strong');
    });
  });

  group('authErrorMessage', () {
    test('maps known errors to friendly messages', () {
      expect(authErrorMessage(Exception('Invalid login credentials')),
          'Incorrect email or password.');
      expect(authErrorMessage(Exception('User already registered')),
          'An account with this email already exists.');
      expect(authErrorMessage(Exception('Email not confirmed')),
          'Please verify your email before signing in.');
      expect(authErrorMessage(Exception('rate limit exceeded')),
          contains('Too many attempts'));
      expect(authErrorMessage(Exception('SocketException: failed')),
          contains('Network error'));
    });

    test('falls back to a generic message', () {
      expect(authErrorMessage(Exception('something weird')),
          'Something went wrong. Please try again.');
    });
  });

  group('Supabase mappers', () {
    test('planFromString maps tiers (default free)', () {
      expect(planFromString('premium_individual'),
          SubscriptionPlan.premiumIndividual);
      expect(planFromString('family'), SubscriptionPlan.premiumFamily);
      expect(planFromString('student'), SubscriptionPlan.student);
      expect(planFromString(null), SubscriptionPlan.free);
      expect(planFromString('garbage'), SubscriptionPlan.free);
    });

    test('profileRowToUser maps snake_case columns', () {
      final user = profileRowToUser({
        'id': 'u1',
        'email': 'avery@x.fm',
        'username': 'avery',
        'display_name': 'Avery',
        'avatar_url': 'http://img',
        'plan': 'student',
        'created_at': '2026-01-01T00:00:00.000Z',
      });
      expect(user.id, 'u1');
      expect(user.displayName, 'Avery');
      expect(user.plan, SubscriptionPlan.student);
      expect(user.isPremium, isTrue);
      expect(user.createdAt, greaterThan(0));
    });

    test('remoteConfigFromRow parses flags with tolerant booleans', () {
      final cfg = remoteConfigFromRow({
        'maintenance_mode': false,
        'disable_youtube': 'true',
        'disable_audius': 1,
        'free_max_playlists': 2,
      });
      expect(cfg.maintenanceMode, isFalse);
      expect(cfg.disableYouTube, isTrue);
      expect(cfg.disableAudius, isTrue);
      expect(cfg.freeMaxPlaylists, 2);
    });

    test('playlistFromRow maps metadata + nested songs', () {
      final pl = playlistFromRow(
        {
          'id': 'p1',
          'name': 'Sunday Slice',
          'owner_id': 'u1',
          'is_public': true,
          'save_count': 5,
        },
        songs: [
          playlistSongFromRow(
              {'song_id': 's1', 'position': 0, 'title': 'T', 'artist': 'A'}),
        ],
      );
      expect(pl.name, 'Sunday Slice');
      expect(pl.isPublic, isTrue);
      expect(pl.saveCount, 5);
      expect(pl.songs.single.songId, 's1');
    });

    test('broadcastFromRow maps fields', () {
      final b = broadcastFromRow({
        'id': 7,
        'message': 'Hello',
        'sender': 'admin',
        'active': true,
        'created_at': '2026-06-01',
      });
      expect(b.id, 7);
      expect(b.message, 'Hello');
      expect(b.active, isTrue);
    });
  });
}
