import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watermelon/data/mock_data.dart';
import 'package:watermelon/state/likes_provider.dart';
import 'package:watermelon/state/player_controller.dart';
import 'package:watermelon/state/subscription_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  group('PlayerController', () {
    test('seeds with the default now-playing track, paused', () {
      final state = container.read(playerProvider);
      expect(state.track?.id, MockData.nowPlayingDefault.id);
      expect(state.isPlaying, false);
      expect(state.position, Duration.zero);
    });

    test('play sets track, resets position and starts playing', () {
      final ctrl = container.read(playerProvider.notifier);
      final track = MockData.sundaySliceTracks[2];
      ctrl.play(track, queue: MockData.sundaySliceTracks);
      final state = container.read(playerProvider);
      expect(state.track?.id, track.id);
      expect(state.isPlaying, true);
      expect(state.position, Duration.zero);
    });

    test('toggle flips play state', () {
      final ctrl = container.read(playerProvider.notifier);
      expect(container.read(playerProvider).isPlaying, false);
      ctrl.toggle();
      expect(container.read(playerProvider).isPlaying, true);
      ctrl.toggle();
      expect(container.read(playerProvider).isPlaying, false);
    });

    test('seekFraction sets position and computes progress', () {
      final ctrl = container.read(playerProvider.notifier);
      ctrl.play(MockData.sundaySliceTracks.first, queue: MockData.sundaySliceTracks);
      ctrl.seekFraction(0.5);
      final state = container.read(playerProvider);
      expect((state.progress - 0.5).abs() < 0.01, true);
    });

    test('next / previous wrap around the queue', () {
      final ctrl = container.read(playerProvider.notifier);
      final tracks = MockData.sundaySliceTracks;
      ctrl.play(tracks.first, queue: tracks);
      ctrl.previous(); // wrap to last
      expect(container.read(playerProvider).track?.id, tracks.last.id);
      ctrl.next(); // wrap back to first
      expect(container.read(playerProvider).track?.id, tracks.first.id);
    });

    test('shuffle and repeat cycle', () {
      final ctrl = container.read(playerProvider.notifier);
      ctrl.toggleShuffle();
      expect(container.read(playerProvider).shuffle, true);
      ctrl.cycleRepeat();
      expect(container.read(playerProvider).repeat, LoopMode.all);
      ctrl.cycleRepeat();
      expect(container.read(playerProvider).repeat, LoopMode.one);
      ctrl.cycleRepeat();
      expect(container.read(playerProvider).repeat, LoopMode.off);
    });
  });

  group('LikesController', () {
    test('seeds with the default liked tracks', () {
      expect(container.read(likesProvider), MockData.defaultLikedTrackIds);
    });

    test('toggle adds and removes', () {
      final ctrl = container.read(likesProvider.notifier);
      expect(ctrl.isLiked('t2'), false);
      ctrl.toggle('t2');
      expect(container.read(likesProvider).contains('t2'), true);
      ctrl.toggle('t2');
      expect(container.read(likesProvider).contains('t2'), false);
    });
  });

  group('SubscriptionController', () {
    test('defaults to monthly + individual', () {
      final state = container.read(subscriptionProvider);
      expect(state.annual, false);
      expect(state.selectedPlanId, 'individual');
    });

    test('price switches with billing period', () {
      final ctrl = container.read(subscriptionProvider.notifier);
      expect(ctrl.priceFor('individual'), r'$9.99');
      ctrl.setAnnual(true);
      expect(ctrl.priceFor('individual'), r'$95.90');
      expect(ctrl.fineprint, contains('annually'));
    });

    test('selectPlan updates selection', () {
      final ctrl = container.read(subscriptionProvider.notifier);
      ctrl.selectPlan('family');
      expect(container.read(subscriptionProvider).selectedPlanId, 'family');
    });
  });
}
