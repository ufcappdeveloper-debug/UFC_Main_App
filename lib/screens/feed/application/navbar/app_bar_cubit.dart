import 'package:flutter_bloc/flutter_bloc.dart';

// AppBar Modes
enum AppBarMode {
  normal,
  channel,
  hidden,
  onlyBg,
  profile,
}

// AppBar Cubit
class AppBarCubit extends Cubit<AppBarMode> {
  AppBarCubit() : super(AppBarMode.normal);

  void setMode(AppBarMode mode) => emit(mode);
}

// Top bar height provider (just a constant here for simplicity)

class AppBarHeightCubit extends Cubit<double> {
  AppBarHeightCubit() : super(74); // default height

  void setHeight(double height) => emit(height);
}

// Bottom Nav Index for additional state
class BottomNavIndex {
  final bool community;
  final bool farm;

  BottomNavIndex({
    required this.community,
    required this.farm,
  });

  BottomNavIndex copyWith({
    bool? community,
    bool? farm,
  }) {
    return BottomNavIndex(
      community: community ?? this.community,
      farm: farm ?? this.farm,
    );
  }
}

// Cubit to manage BottomNavIndex state
class BottomNavIndexCubit extends Cubit<BottomNavIndex> {
  BottomNavIndexCubit() : super(BottomNavIndex(community: true, farm: true));

  void update({bool? community, bool? farm}) {
    emit(state.copyWith(community: community, farm: farm));
  }
}

// Cubit to manage selected tab index
class SelectedAppbarItemCubit extends Cubit<int> {
  SelectedAppbarItemCubit() : super(0);

  void setIndex(int index) => emit(index);
}
