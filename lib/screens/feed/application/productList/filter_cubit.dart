import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterState(filterItems: [['',''],[false,false]], filterPrice: 500));

  void updateFilter(int ind1, int ind2, int ind3, int ind4, String value){
    List<List> current = state.filterItems;
    if (!current[ind3][ind4]) {
      current[ind1][ind2] = value;
      current[ind3][ind4] = true;
    } else {
      if (current[ind1][ind2] == value) {
        current[ind1][ind2] = '';
        current[ind3][ind4] = false;
      } else {
        current[ind1][ind2] = value;
        current[ind3][ind4] = true;
      }
    }
    emit(state.copyWith(filterItems: current));
  }

  void updatePrice(double price){
    List<List> current = state.filterItems;
    emit(state.copyWith(filterItems: current, filterPrice: price));
  }
}
