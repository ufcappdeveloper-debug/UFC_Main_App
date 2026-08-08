import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/barn/livestock.dart';
import '../../domain/usecase/livestock_list_by_category_usecase.dart';

part 'livestock_list_by_category_state.dart';

class LivestockListByCategoryCubit extends Cubit<LivestockListByCategoryState> {
  final LivestockListByCategoryUseCase livestockList;
  LivestockListByCategoryCubit(this.livestockList)
      : super(LivestockListByCategoryInitial());

  Future<void> getLivestocks() async {
    emit(LivestockListByCategoryLoading());
    try {
      final data = await livestockList(null);
      emit(LivestockListByCategoryLoaded(data));
    } catch (e) {
      emit(LivestockListByCategoryError(e.toString()));
    }
  }

  Future<void> getLivestocksByCategory(String? category) async {
    final previousState = state;
    emit(LivestockListByCategoryLoading());
    try {
      final data = await livestockList(category);

      if (previousState is LivestockListByCategoryLoaded) {
        final updated = AnimalData(
          animals: data.animals,
          animalCategories: previousState.animals?.animalCategories,
        );
        emit(LivestockListByCategoryLoaded(updated));
      } else {
        emit(LivestockListByCategoryLoaded(data));
      }
    } catch (e) {
      emit(LivestockListByCategoryError(e.toString()));
    }
  }
}
