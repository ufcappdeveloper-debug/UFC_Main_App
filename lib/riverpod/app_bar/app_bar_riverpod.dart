// in your riverpod/state.dart or similar
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appBarHeightProvider = StateProvider<double>((ref) => 380);

final tabBarHeightProvider = StateProvider<double>((ref) => 70); // default tab height

final StateProvider<int> selectedAppbarItem = StateProvider<int>((ref)=> 0);

//farm page index
final farmBodySelectedIndexProvider = StateProvider<int>((ref) => 0);
