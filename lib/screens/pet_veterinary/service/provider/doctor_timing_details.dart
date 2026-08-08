import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/doctor_service.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_timing_model.dart'
    show DoctorTiming;
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part 'doctor_timing_details.g.dart';

@Riverpod(keepAlive: true)
class DoctorTimingDetails extends _$DoctorTimingDetails {
  @override
  FutureOr<DoctorTiming?> build() async {
    return DoctorTiming(message: "No timings available", doctorTimings: []);
  }

  Future<void> fetchDoctorTiming(int id) async {
    state = const AsyncValue.loading();
    try {
      final response = await DoctorService().fetchDoctorTiming(id);

      state = AsyncValue.data(response);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
