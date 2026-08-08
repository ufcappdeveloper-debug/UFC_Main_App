// import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';

// class AppointmentModel {
//   int? id;
//   int? doctorId;
//   int? userId;
//   int? duration;
//   String? startTime;
//   String? endTime;
//   String? timeZone;
//   String? status;
//   String? paymentStatus;
//   String? deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   Doctor? doctor;

//   AppointmentModel(
//       {this.id,
//       this.doctorId,
//       this.userId,
//       this.duration,
//       this.startTime,
//       this.endTime,
//       this.timeZone,
//       this.status,
//       this.paymentStatus,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.doctor});

//   AppointmentModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     doctorId = json['doctor_id'];
//     userId = json['user_id'];
//     duration = json['duration'];
//     startTime = json['start_time'];
//     endTime = json['end_time'];
//     timeZone = json['time_zone'];
//     status = json['status'];
//     paymentStatus = json['payment_status'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['doctor_id'] = doctorId;
//     data['user_id'] = userId;
//     data['duration'] = duration;
//     data['start_time'] = startTime;
//     data['end_time'] = endTime;
//     data['time_zone'] = timeZone;
//     data['status'] = status;
//     data['payment_status'] = paymentStatus;
//     data['deleted_at'] = deletedAt;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;

//     return data;
//   }
// }

import 'package:ufc_mobile/models/pagination/pagination_model.dart';
import 'package:ufc_mobile/models/schedule/prescription_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';

class AppointmentModel {
  int? id;
  int? doctorId;
  int? userId;
  int? duration;
  String? startTime;
  String? endTime;
  String? timeZone;
  String? status;
  String? paymentStatus;
  String? deletedAt;
  double? rating;
  String? createdAt;
  String? updatedAt;
  Doctor? doctor;
  int? sessions;
  String? animalUniqueKey;
  String? animalRef;
  List<PrescriptionModel>? prescriptions;

  AppointmentModel({
    this.id,
    this.doctorId,
    this.userId,
    this.duration,
    this.startTime,
    this.endTime,
    this.timeZone,
    this.status,
    this.paymentStatus,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.doctor,
    this.sessions,
    this.rating,
    this.prescriptions,
    this.animalUniqueKey,
    this.animalRef,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    userId = json['user_id'];
    duration = json['duration'];
    startTime = json['start_time'];
    rating = (json['average_rating'] as num?)?.toDouble();
    endTime = json['end_time'];
    timeZone = json['time_zone'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
    sessions = json['total_sessions'];
    animalUniqueKey = json['animal_unique_key'];
    animalRef = json['animal_ref'];
    if (json['prescriptions'] != null) {
      prescriptions = List<PrescriptionModel>.from(
        json['prescriptions'].map((x) => PrescriptionModel.fromJson(x)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['user_id'] = userId;
    data['duration'] = duration;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['time_zone'] = timeZone;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total_sessions'] = sessions;
    if (doctor != null) {
      data['doctor'] = {
        'id': doctor!.id,
        'name_en': doctor!.nameEn,
        'name_ar': doctor!.nameAr,
        'profile_image': doctor!.profileImage,
        'country_code': doctor!.countryCode,
        'phone_number': doctor!.phoneNumber,
        'available_in': doctor!.availableIn,
        'rates': doctor!.rates,
        'fee_per_min': doctor!.feePerMin,
        'about_en': doctor!.aboutEn,
        'about_ar': doctor!.aboutAr,
        'rating': doctor!.rating,
        'specialization_en': doctor!.specializationEn,
        'specialization_ar': doctor!.specializationAr,
        'gender': doctor!.gender,
        'created_at': doctor!.createdAt,
        'updated_at': doctor!.updatedAt,
        'deleted_at': doctor!.deletedAt,
        'time_zone': doctor!.timeZone,
        'booking_date': doctor!.bookingDate,
        'booking_time': doctor!.bookingTime,
        'duration': doctor!.duration,
        'session': doctor!.session,
        'session_type': doctor!.sessionType,
        'language': doctor!.languages,
        'experience': doctor!.experience,
      };
    }
    return data;
  }
}

class BookingSchedule {
  String? message;
  Pagination? pagination;
  List<AppointmentModel>? bookings;

  BookingSchedule({
    this.message,
    this.pagination,
    this.bookings,
  });

  BookingSchedule.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    final bookingsJson = json['bookings'];
    if (bookingsJson != null) {
      pagination = Pagination.fromJson({
        'current_page': bookingsJson['current_page'],
        'last_page': bookingsJson['last_page'],
        'per_page': bookingsJson['per_page'],
        'total': bookingsJson['total'],
        'next_page_url': bookingsJson['next_page_url'],
        'prev_page_url': bookingsJson['prev_page_url'],
      });

      if (bookingsJson['data'] != null) {
        bookings = <AppointmentModel>[];
        bookingsJson['data'].forEach((v) {
          bookings!.add(AppointmentModel.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (pagination != null) {
      data['bookings'] = pagination!.toJson();
    }
    if (bookings != null) {
      data['bookings']['data'] = bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
