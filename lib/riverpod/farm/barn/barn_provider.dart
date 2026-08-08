import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../../data/barn_service.dart';
import '../../../screens/farm/domain/entities/barn/barn_model.dart';

part "barn_provider.g.dart";

@Riverpod(keepAlive: true)
class BarnAsync extends _$BarnAsync {
  @override
  FutureOr<List<BarnModel>> build() async {
    return [];
  }

  Future<List<BarnModel>?> getBarn() async {
    state = const AsyncValue.loading();
    try {
      final barns = await BarnService().getBarns();
      state = AsyncValue.data(barns);
      return barns;
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
      return null;
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return null;
    }
  }

  Future<BarnModel?> addBarn(Map<String, dynamic> data,
      {int? editBarnId}) async {
    try {
      BarnModel newBarn =
          await BarnService().addBarn(data, editBarnId: editBarnId);
      if (editBarnId == null) {
        final updatedState = [...(state.value ?? <BarnModel>[]), newBarn];
        state = AsyncValue.data(updatedState);
      } else {
        final updatedState = (state.value ?? <BarnModel>[])
            .map((barn) => barn.id == editBarnId ? newBarn : barn)
            .toList();

        state = AsyncValue.data(updatedState);
      }
      return newBarn;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteBarn(int id) async {
    try {
      final current = state.value ?? [];
      await BarnService().deleteBarn(id);

      final updated = current.where((barn) => barn.id != id).toList();
      state = AsyncValue.data(updated);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
