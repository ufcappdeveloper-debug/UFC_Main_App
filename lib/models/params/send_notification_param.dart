import 'package:ufc_mobile/global/shared/functions/common_functions.dart';

class SendNotificationParam {
  String title;
  String body;
  SendNotificationDataParam? data;
  int? sendToDoctorId;

  SendNotificationParam({
    required this.title,
    required this.body,
    this.data,
    required this.sendToDoctorId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['send_to_doctor_id'] = sendToDoctorId;
    return data;
  }
}

class SendNotificationDataParam {
  bool? isCallEnded;
  String? patientId;
  String? bookingId;
  String? occupation;
  String? patientName;

  SendNotificationDataParam({
    this.patientId,
    this.bookingId,
    this.occupation,
    this.isCallEnded,
    this.patientName,
  });

  Map<String, String?> toJson() {
    final Map<String, String?> data = <String, String?>{};
    data['is_call'] = 'true';
    if (!isStringEmpty(patientId)) data['patient_id'] = patientId;
    if (!isStringEmpty(bookingId)) data['booking_id'] = bookingId;
    if (!isStringEmpty(occupation)) data['occupation'] = occupation;
    if (!isStringEmpty(patientName)) data['patient_name'] = patientName;
    if (isCallEnded != null) data['is_call_ended'] = isCallEnded?.toString();
    return data;
  }
}
