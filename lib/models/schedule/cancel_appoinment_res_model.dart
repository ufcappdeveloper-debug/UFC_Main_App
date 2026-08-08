class CancelBookingAppoinmentRes {
  String? message;
  bool? status;
  CancelBookingAppoinmentRes({
    this.message,
    this.status,
  });

  CancelBookingAppoinmentRes.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = (json['status'] == true || json['status'] == 1);
  }
}
