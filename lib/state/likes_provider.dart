import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';

/// The set of liked track ids, shared across Home, Playlist, Player and the
/// mini-player so a heart toggled in one place updates everywhere.
class LikesController extends Notifier<Set<String>> {
  @override
  Set<String> build() => {...MockData.defaultLikedTrackIds};

  bool isLiked(String id) => state.contains(id);

  void toggle(String id) {
    final next = {...state};
    next.contains(id) ? next.remove(id) : next.add(id);
    state = next;
  }
}

final likesProvider =
    NotifierProvider<LikesController, Set<String>>(LikesController.new);

/// Convenience: watch the liked-state of a single track id.
final isLikedProvider = Provider.family<bool, String>((ref, id) {
  return ref.watch(likesProvider).contains(id);
});
