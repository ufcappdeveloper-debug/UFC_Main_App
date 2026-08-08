import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/appointment_service.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';

part 'appointment_details_riverpod.g.dart';

@Riverpod(keepAlive: true)
class AppointmentDetails extends _$AppointmentDetails {
  @override
  FutureOr<AppointmentModel?> build() async {
    return null; // Initial state
  }

  Future<void> fetchAppointmentDetails(int bookingId) async {
    state = const AsyncValue.loading();
    try {
      final response =
          await AppointmentService().getAppoinmentDetails(bookingId);
      state = AsyncValue.data(response);
    } on DioException catch (e) {
      state = AsyncValue.error(
          e.message ?? 'Something went wrong', StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  void clearData() {
    state = const AsyncValue.data(null);
  }
}
