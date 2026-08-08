import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/doctor_service.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';

part 'doctor_details_riverpod.g.dart';

@Riverpod(keepAlive: true)
class DoctorDetails extends _$DoctorDetails {
  @override
  FutureOr<Doctor?> build() async {
    return null;
  }

  Future<void> fetchDoctorById(int id) async {
    state = AsyncValue.loading();
    try {
      final response = await DoctorService().fetchDoctorById(id);

      state = AsyncValue.data(response);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  clearData() {
    state = AsyncValue.data(null);
  }
}
