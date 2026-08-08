import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/barn/animal_model.dart';
import '../../domain/entities/mothers_and_babies.dart';
import '../../domain/usecase/mothers_and_babies_chart_usecase.dart';
import '../../domain/usecase/mothers_babies_usecase.dart';

part 'mothers_babies_state.dart';

class MothersBabiesCubit extends Cubit<MothersBabiesState> {
  final MothersBabiesUsecase mothersBabiesUsecase;
  final MothersAndbabiesChartUsecase chartUsecase;

  MothersBabiesCubit(this.mothersBabiesUsecase, this.chartUsecase)
      : super(MothersBabiesInitial());
  int page = 1;
  List<AnimalModel> data = [];
  Future<void> getLivestocks(bool isMother, bool loadData,
      {String? category}) async {
    try {
      MothersBabiesChart? chart;
      if (!loadData) {
        page = 1;
        data = [];
        emit(MothersBabiesLoading());
        chart = await chartUsecase(category);
      }
      Map<String, dynamic> body = {
        'per_page': 50,
        'page': page,
        'requested_data': isMother ? 'mothers' : 'babies',
        if (category != null && category != 'all') 'animal_category': category
      };
      final result = await mothersBabiesUsecase(body);
      final bool hasReachedMax = result.isEmpty;
      data = data..addAll(result);
      page++;
      var currentState = state;
      final chartToUse = chart ??
          (currentState is MothersBabiesLoaded ? currentState.chart : null) ??
          (currentState is MothersBabiesLoadingMore
              ? currentState.chart
              : null);
      if (currentState is MothersBabiesLoaded || page == 1) {
        emit(MothersBabiesLoadingMore(
          data,
          chartToUse,
          hasReachedMax,
        ));
      } else {
        emit(MothersBabiesLoaded(
          data,
          chartToUse,
          hasReachedMax,
        ));
      }
    } catch (e) {
      emit(MothersBabiesError(e.toString()));
    }
  }
}
