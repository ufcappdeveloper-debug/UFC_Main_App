import 'package:ufc_mobile/screens/feed/domain/entities/product/product_rating_model.dart';

class Doctor {
  final int? id;
  final String? nameEn;
  final String? nameAr;
  final String? profileImage;
  final String? countryCode;
  final String? phoneNumber;
  final String? availableIn;
  final double? rates;
  final String? feePerMin;
  final String? aboutEn;
  final String? aboutAr;
  final double? rating;
  final String? specializationEn;
  final String? specializationAr;
  final String? gender;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? timeZone;
  final String? bookingDate;
  final String? bookingTime;
  final int? duration;
  final int? session;
  final String? sessionType;
  final List<String>? languages;
  final String? experience;
  final String? experienceAr;
  final String? nearestAvailabletime;
  final List<ReviewModel>? reviews;
  Doctor({
    this.id,
    this.nameEn,
    this.nameAr,
    this.profileImage,
    this.countryCode,
    this.phoneNumber,
    this.availableIn,
    this.rates,
    this.feePerMin,
    this.aboutEn,
    this.aboutAr,
    this.specializationEn,
    this.specializationAr,
    this.rating,
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.timeZone,
    this.bookingDate,
    this.bookingTime,
    this.duration,
    this.session,
    this.experience,
    this.sessionType,
    this.experienceAr,
    this.languages,
    this.nearestAvailabletime,
    this.reviews,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'] ?? '',
      profileImage: json['profile_image'] ?? '',
      countryCode: json['country_code'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      aboutEn: json['about_en'] ?? '',
      aboutAr: json['about_ar'] ?? '',
      specializationEn: json['specialization_en'] ?? '',
      specializationAr: json['specialization_ar'] ?? '',
      gender: json['gender'] as String?,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      timeZone: json['time_zone'] ?? '',
      nearestAvailabletime: json['nearest_availability'],
      languages: (json['languages'] as List<dynamic>?)
          ?.map((lang) => lang['language'].toString())
          .toList(),
      experience: json['experience'],
      experienceAr: json['experience_ar'],
      rating: (json['average_rating'] as num?)?.toDouble(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((item) => ReviewModel.fromJson(item))
          .toList(),
    );
  }

  static List<Doctor> fromList(List<dynamic> list) {
    return list.map((item) => Doctor.fromJson(item)).toList();
  }
}

class Review {
  final int? id;
  final int? doctorId;
  final int? userId;
  final int? doctorBookingId;
  final String? review;
  final int? rating;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Review({
    this.id,
    this.doctorId,
    this.userId,
    this.doctorBookingId,
    this.review,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      doctorId: json['doctor_id'] is int
          ? json['doctor_id']
          : int.tryParse(json['doctor_id']?.toString() ?? ''),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? ''),
      doctorBookingId: json['doctor_booking_id'] is int
          ? json['doctor_booking_id']
          : int.tryParse(json['doctor_booking_id']?.toString() ?? ''),
      review: json['review']?.toString(),
      rating: json['rating'] is int
          ? json['rating']
          : int.tryParse(json['rating']?.toString() ?? ''),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
    );
  }
}

class PaginatedDoctorsResponse {
  final List<Doctor> doctors;
  final int? currentPage;
  final int? lastPage;
  final String? nextPageUrl;

  PaginatedDoctorsResponse({
    required this.doctors,
    this.currentPage,
    this.lastPage,
    this.nextPageUrl,
  });

  factory PaginatedDoctorsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedDoctorsResponse(
      // doctors: Doctor.fromList(json['data']),
      doctors: json['data'] != null ? Doctor.fromList(json['data']) : [],
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      nextPageUrl: json['next_page_url'],
    );
  }
}
