class DoctorReviewRequest {
  final int doctorId;
  final int doctorBookingId;
  final int rating;
  final String review;

  DoctorReviewRequest({
    required this.doctorId,
    required this.doctorBookingId,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toJson() => {
        "doctor_id": doctorId,
        "doctor_booking_id": doctorBookingId,
        "rating": rating,
        "review": review,
      };
}

class DoctorReviewResponse {
  final int id;
  final int userId;
  final int doctorId;
  final int doctorBookingId;
  final int rating;
  final String review;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorReviewResponse({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.doctorBookingId,
    required this.rating,
    required this.review,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorReviewResponse.fromJson(Map<String, dynamic> json) {
    return DoctorReviewResponse(
      id: json['id'],
      userId: json['user_id'],
      doctorId: json['doctor_id'],
      doctorBookingId: json['doctor_booking_id'],
      rating: json['rating'],
      review: json['review'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
