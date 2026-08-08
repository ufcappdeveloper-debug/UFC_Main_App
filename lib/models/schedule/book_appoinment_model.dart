import 'package:ufc_mobile/models/schedule/appointment_model.dart';

class BookAppoinmentModel {
  final int doctorId;
  final String? animalUniqueKey;
  final String startTime;
  final String duration;
  final String? notes;

  BookAppoinmentModel({
    required this.doctorId,
    required this.startTime,
    required this.duration,
    this.animalUniqueKey,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'doctor_id': doctorId,
      'start_time': startTime,
      'duration': duration,
    };

    if (animalUniqueKey != null) {
      data['animal_unique_key'] = animalUniqueKey;
    }

    if (notes != null && notes!.isNotEmpty) {
      data['notes'] = notes;
    }

    return data;
  }
}

class BookingResponse {
  final String? message;
  final AppointmentModel? booking;

  BookingResponse({this.message, this.booking});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      message: json['message'] as String?,
      booking: json['booking'] != null
          ? AppointmentModel.fromJson(json['booking'])
          : null,
    );
  }
}
