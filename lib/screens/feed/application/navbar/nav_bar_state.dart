class BottomNavState {
  final int selectedIndex;
  final bool feed;
  final bool farm;
  final bool community;

  BottomNavState({
    required this.selectedIndex,
    this.feed = true,
    this.farm = true,
    this.community = true,
  });

  BottomNavState copyWith({
    int? selectedIndex,
    bool? feed,
    bool? farm,
    bool? community,
  }) {
    return BottomNavState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      feed: feed ?? this.feed,
      farm: farm ?? this.farm,
      community: community ?? this.community,
    );
  }
}