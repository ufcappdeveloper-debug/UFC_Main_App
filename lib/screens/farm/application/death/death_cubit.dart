import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/barn/animal_model.dart';
import '../../domain/entities/dashboard/dashboard_card_model.dart';
import '../../domain/entities/donut_chart_model.dart';
import '../../domain/usecase/death_donut_chart_usecase.dart';
import '../../domain/usecase/death_line_chart_usecase.dart';
import '../../domain/usecase/death_usecase.dart';

part 'death_state.dart';

class DeathCubit extends Cubit<DeathState> {
  final DeathUsecase deathUsecase;
  final DeathDonutChartUsecase deathDonutChartUsecase;
  final DeathLineChartUsecase deathLineChartUsecase;

  DeathCubit(
    this.deathUsecase,
    this.deathDonutChartUsecase,
    this.deathLineChartUsecase,
  ) : super(DeathInitial());

  int page = 1;
  int limit = 50;
  List<AnimalModel> animals = [];

  Future<void> getDeathData({bool loadMore = false, String? category}) async {
    try {
      DonutChartModel? donutChart;
      CardModel? lineChart;

      if (!loadMore) {
        page = 1;
        animals = [];
        emit(DeathLoading());
        donutChart = await deathDonutChartUsecase(category!='all'? category:null);
        lineChart = await deathLineChartUsecase(category!='all'? category:null);
      }

      final result = await deathUsecase({
        'page': page,
        'per_page': limit,
        if (category != null && category != 'all') 'animal_category': category
      });

      final bool hasMore = result.isNotEmpty;

      animals.addAll(result);
      page++;

      final currentState = state;
      final donutToUse = donutChart ??
          (currentState is DeathLoaded ? currentState.donutChart : null) ??
          (currentState is DeathLoadingMore ? currentState.donutChart : null);

      final lineToUse = lineChart ??
          (currentState is DeathLoaded ? currentState.lineChart : null) ??
          (currentState is DeathLoadingMore ? currentState.lineChart : null);

      if (currentState is DeathLoaded || page == 1) {
        emit(DeathLoadingMore(
          animals,
          donutToUse,
          lineToUse,
          hasMore,
        ));
      } else {
        emit(DeathLoaded(
          animals,
          donutToUse,
          lineToUse,
          hasMore,
        ));
      }
    } catch (e) {
      emit(DeathError(e.toString()));
    }
  }
}
