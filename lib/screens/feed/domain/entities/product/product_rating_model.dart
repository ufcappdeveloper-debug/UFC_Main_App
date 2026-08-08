import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';

class ReviewModel {
  final int? id;
  final int? productId;
  final int? doctorId;
  final int? userId;
  final int? doctorBookingId;
  final double? rating;
  final String? review;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final UserModel? user;

  ReviewModel({
    this.id,
    this.productId,
    this.doctorId,
    this.userId,
    this.doctorBookingId,
    this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: _toInt(json['id']),
      productId: _toInt(json['product_id']),
      doctorId: _toInt(json['doctor_id']),
      userId: _toInt(json['user_id']),
      doctorBookingId: _toInt(json['doctor_booking_id']),
      rating: _toDouble(json['rating']),
      review: json['review']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['doctor_id'] = doctorId;
    data['user_id'] = userId;
    data['doctor_booking_id'] = doctorBookingId;
    data['rating'] = rating;
    data['review'] = review;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (user != null) data['user'] = user!.toJson();
    return data;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    return double.tryParse(value.toString());
  }
}
