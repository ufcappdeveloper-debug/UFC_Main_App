import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../data/farm_reports_service.dart';
import '../../screens/farm/domain/entities/barn/livestock.dart';

part "get_livestock_async.g.dart";

@Riverpod(keepAlive: true)
class GetLivestock extends _$GetLivestock {
  @override
  FutureOr<AnimalData?> build() async {
    return null;
  }

  Future<void> getLiveStocks() async {
    state = const AsyncValue.loading();
    try {
      final selectedAnimalRef = state.value?.selectedAnimalRef;
      final selectedAnimalKey = state.value?.selectedAnimalKey;
      final data = await FarmReportsService().getLivestocks();
      state = AsyncValue.data(AnimalData(
        animalCategories: data.animalCategories,
        animals: data.animals,
        selectedAnimalRef: selectedAnimalRef,
        selectedAnimalKey: selectedAnimalKey,
      ));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> getLiveStocksByCategory(String? category, int? barnId) async {
    state = const AsyncValue.loading();
    try {
      var currentState = state.value;
      final data = await FarmReportsService().getLivestocks(category: category, barnId: barnId);
      final updatedState = AnimalData(
        animalCategories: currentState?.animalCategories,
        selectedAnimalRef: currentState?.selectedAnimalRef,
        selectedAnimalKey: currentState?.selectedAnimalKey,
        animals: data.animals,
      );
      state = AsyncValue.data(updatedState);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> setAnimalRef(String? animalRef, {String? selectedAnimalKey}) async {
    var currentState = state.value;
    var updatedState = AnimalData(
      animalCategories: currentState?.animalCategories,
      selectedAnimalRef: animalRef,
      animals: currentState?.animals,
      selectedAnimalKey: selectedAnimalKey,
    );
    state = AsyncValue.data(updatedState);
  }
}
