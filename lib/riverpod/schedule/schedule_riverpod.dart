import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/appointment_service.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/models/schedule/book_appoinment_model.dart';
import 'package:ufc_mobile/models/schedule/cancel_appoinment_res_model.dart';

part 'schedule_riverpod.g.dart';

@Riverpod(keepAlive: true)
class AppointmentAsync extends _$AppointmentAsync {
  @override
  FutureOr<Map<String, List<AppointmentModel>>?> build() async {
    return {"upcoming": [], "past": []};
  }

  Future<Map<String, int>> getAppointments() async {
    state = const AsyncValue.loading();
    final lastPages = {"upcoming": 1, "past": 1};

    try {
      final updatedState = {
        "upcoming": <AppointmentModel>[],
        "past": <AppointmentModel>[],
      };

      for (final type in ["upcoming", "past"]) {
        int currentPage = 1;
        List<AppointmentModel> allFetchedValid = [];

        while (true) {
          final result =
              await AppointmentService().getAppointments(type, currentPage);
          final validAppointments = result.validAppointments;
          allFetchedValid.addAll(validAppointments);

          if (result.dataWasEmpty || allFetchedValid.length >= 10) {
            break;
          }

          currentPage++;
        }

        updatedState[type] = allFetchedValid;
        lastPages[type] = currentPage;
      }

      state = AsyncValue.data(updatedState);
      return lastPages;
    } on DioException catch (e) {
      state =
          AsyncValue.error(e.message ?? "Unknown error", StackTrace.current);
      return lastPages;
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return lastPages;
    }
  }

  Future<int?> loadAppointments(int page, String type) async {
    try {
      final updatedState = Map<String, List<AppointmentModel>>.from(
        state.value ?? {"upcoming": [], "past": []},
      );

      final appointments = await _fetchPaginatedAppointments(type, page);

      if (appointments.isEmpty) return null;

      updatedState[type]?.addAll(appointments);
      state = AsyncValue.data(updatedState);

      return page + ((appointments.length >= 10) ? 1 : 0);
    } on DioException catch (e) {
      state =
          AsyncValue.error(e.message ?? "Unknown error", StackTrace.current);
      return null;
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
      return null;
    }
  }

  Future<List<AppointmentModel>> _fetchPaginatedAppointments(
      String type, int startPage) async {
    List<AppointmentModel> allFetchedValid = [];
    int currentPage = startPage;

    while (true) {
      final result =
          await AppointmentService().getAppointments(type, currentPage);
      final validAppointments = result.validAppointments;

      allFetchedValid.addAll(validAppointments);

      if (result.dataWasEmpty || allFetchedValid.length >= 10) {
        break;
      }

      currentPage++;
    }

    return allFetchedValid;
  }

  Future<CancelBookingAppoinmentRes?> cancelAppointMent(int bookingId) async {
    state = const AsyncValue.loading();
    try {
      final result = await AppointmentService.cancelAppointment(bookingId);
      getAppointments();
      return result;
    } on DioException catch (e) {
      state =
          AsyncValue.error(e.message ?? "Unknown error", StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
    return null;
  }

  Future<BookingResponse?> rescheduleAppointment(
    int bookingId,
    String startTime,
    int duration, {
    String? animalUniqueKey,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final bookingData = BookAppoinmentModel(
        doctorId: 0,
        startTime: startTime,
        duration: duration.toString(),
        animalUniqueKey: animalUniqueKey,
        notes: notes,
      );

      final Map<String, dynamic> jsonData = bookingData.toJson();
      jsonData['booking_id'] = bookingId;

      final result = await AppointmentService.rescheduleAppointment(
        BookAppoinmentModel(
          doctorId: bookingData.doctorId,
          startTime: bookingData.startTime,
          duration: bookingData.duration,
          animalUniqueKey: bookingData.animalUniqueKey,
          notes: bookingData.notes,
        ),
      );

      getAppointments();
      return result;
    } on DioException catch (e) {
      state =
          AsyncValue.error(e.message ?? "Unknown error", StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
    return null;
  }
}
