class BookingAppoinmentResponse {
  String? message;
  Booking? booking;

  BookingAppoinmentResponse({this.message, this.booking});

  BookingAppoinmentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    return data;
  }
}

class Booking {
  int? doctorId;
  int? userId;
  String? startTime;
  String? endTime;
  String? status;
  String? paymentStatus;
  String? timeZone;
  String? updatedAt;
  String? createdAt;
  int? id;

  Booking(
      {this.doctorId,
      this.userId,
      this.startTime,
      this.endTime,
      this.status,
      this.paymentStatus,
      this.timeZone,
      this.updatedAt,
      this.createdAt,
      this.id});

  Booking.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    userId = json['user_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    timeZone = json['time_zone'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctor_id'] = doctorId;
    data['user_id'] = userId;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['time_zone'] = timeZone;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
