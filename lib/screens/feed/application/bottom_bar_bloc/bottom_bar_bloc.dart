import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBottomNavCubit extends Cubit<int> {
  FeedBottomNavCubit() : super(0);

  void changeTab(int index) => emit(index);
}
