import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/models/schedule/appointment_page_result.dart';
import 'package:ufc_mobile/models/schedule/book_appoinment_model.dart';
import 'package:ufc_mobile/models/schedule/cancel_appoinment_res_model.dart';

class AppointmentService {
  Future<AppointmentPageResult> getAppointments(String type, int page) async {
    try {
      Response res = await api.get(
        "api/ufc/v1/doctor/get_booking_schedule",
        queryParameters: {
          "type": type,
          "page": page,
        },
      );

      final bookingsJson = res.data["bookings"];
      if (bookingsJson != null && bookingsJson["data"] != null) {
        final List data = bookingsJson["data"];
        final filtered = data
            .where((json) =>
                json["status"] != "cancelled" && json["doctor"] != null)
            .map((json) => AppointmentModel.fromJson(json))
            .toList();

        return AppointmentPageResult(
          validAppointments: filtered,
          hadOnlyCancelled: filtered.isEmpty && data.isNotEmpty,
          dataWasEmpty: data.isEmpty,
        );
      } else {
        return AppointmentPageResult(
            validAppointments: [], hadOnlyCancelled: false);
      }
    } on DioException catch (e) {
      throw Exception(e.error);
    }
  }

  static Future<BookingResponse> createAppoinment(
      BookAppoinmentModel bookingData) async {
    try {
      Response res = await api.post(
        "api/ufc/v1/doctor/create_doctor_booking",
        data: bookingData.toJson(),
      );
      return BookingResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.error);
    }
  }

  static Future<CancelBookingAppoinmentRes> cancelAppointment(
    int bookingId,
  ) async {
    try {
      Response res = await api.post(
        "api/ufc/v1/doctor/cancel_doctor_booking",
        data: {"booking_id": bookingId},
      );

      return CancelBookingAppoinmentRes.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.error);
    }
  }

  static Future<BookingResponse> rescheduleAppointment(
      BookAppoinmentModel bookingData) async {
    try {
      Response res = await api.post(
        "api/ufc/v1/doctor/update_doctor_booking",
        data: bookingData.toJson(),
      );
      return BookingResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.error);
    }
  }

  Future<AppointmentModel?> getAppoinmentDetails(int bookingID) async {
    try {
      Response res = await api.get(
        "api/ufc/v1/doctor/get_booking_details/$bookingID",
      );

      final bookingsJson = res.data;
      if (bookingsJson != null && bookingsJson["data"] != null) {
        return AppointmentModel.fromJson(bookingsJson["data"]);
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw Exception(e.error);
    }
  }
}
