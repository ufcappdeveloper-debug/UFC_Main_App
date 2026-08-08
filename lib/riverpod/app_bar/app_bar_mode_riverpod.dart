// riverpod/state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppBarModeRiverpod {
  normal,
  channel,
  hidden,
}

final appBarModeProvider =
    StateProvider<AppBarModeRiverpod>((ref) => AppBarModeRiverpod.normal);
// or use enum: enum AppBarMode { default, channel } for more clarity

final isHome = StateProvider<BottomNavIndex>(
    (ref) => BottomNavIndex(community: true, farm: true, feed: true));

class BottomNavIndex {
  final bool community;
  final bool farm;
  final bool feed;

  BottomNavIndex({
    required this.community,
    required this.farm,
    required this.feed,
  });

  BottomNavIndex copyWith({
    bool? community,
    bool? farm,
    bool? feed,
  }) {
    return BottomNavIndex(
      community: community ?? this.community,
      farm: farm ?? this.farm,
      feed: feed ?? this.feed,
    );
  }
}
