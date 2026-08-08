import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/farm_vaccine_service.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/vaccine_model.dart';
import '../../../global/shared/functions/dio.dart';

part "get_vaccination.g.dart";

@Riverpod(keepAlive: true)
class GetVaccination extends _$GetVaccination {
  List<VaccineModel>? _vaccines;

  @override
  FutureOr<List<VaccineModel>?> build() async {
    return null;
  }

  Future<void> getGetVaccination() async {
    state = const AsyncValue.loading();
    try {
      final vaccines = await FarmVaccineService().getVaccinTypes();
      _vaccines = vaccines;
      state = AsyncValue.data(vaccines);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> addVaccine(List<VaccineSchedules> data, String? animal,
      {bool isCategory = false, String? gender}) async {
    try {
      final param = VaccineParam(
          animal: animal,
          gender: gender?.toLowerCase(),
          isCategory: isCategory,
          vaccineSchedules: data);
      await FarmVaccineService().addVaccine(param);
      return null;
    } on DioException catch (e) {
      return extractErrorMessage(e.response?.data);
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  /// Update date and duration for a vaccine
  void updateVaccineData(int? id, {String? date, String? duration}) {
    if (_vaccines == null) return;

    final index = _vaccines!.indexWhere((v) => v.id == id);
    if (index != -1) {
      final old = _vaccines![index];
      _vaccines![index] = VaccineModel(
        id: old.id,
        vaccineEn: old.vaccineEn,
        vaccineAr: old.vaccineAr,
        date: date ?? old.date,
        duration: duration ?? old.duration,
      );
      state = AsyncValue.data(List.from(_vaccines!));
    }
  }

  void clearVaccineData(){
    state = AsyncValue.data(null);
  }
}
