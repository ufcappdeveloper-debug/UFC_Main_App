import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarHeightCubit extends Cubit<double> {
  AppBarHeightCubit() : super(370);

  void setHeight(double height) => emit(height);
}
