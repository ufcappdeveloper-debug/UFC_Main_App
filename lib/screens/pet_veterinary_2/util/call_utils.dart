import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_rating_screen_2.dart';

class CallUtils {
  static String getLocalizedName(BuildContext context, Doctor? doctor) {
    final nameEn = doctor?.nameEn?.trim();
    final nameAr = doctor?.nameAr?.trim();

    if (isEnglish) {
      return (nameEn?.isNotEmpty ?? false)
          ? nameEn!
          : (nameAr?.isNotEmpty ?? false)
              ? nameAr!
              : '';
    } else {
      return (nameAr?.isNotEmpty ?? false)
          ? nameAr!
          : (nameEn?.isNotEmpty ?? false)
              ? nameEn!
              : '';
    }
  }

  static String getLocalizedSpecalizedName(
      BuildContext context, Doctor? doctor) {
    final specEn = doctor?.specializationEn?.trim();
    final specAr = doctor?.specializationAr?.trim();

    if (isEnglish) {
      return (specEn?.isNotEmpty ?? false)
          ? specEn!
          : (specAr?.isNotEmpty ?? false)
              ? specAr!
              : '';
    } else {
      return (specAr?.isNotEmpty ?? false)
          ? specAr!
          : (specEn?.isNotEmpty ?? false)
              ? specEn!
              : '';
    }
  }

  static void navigateToDoctorRatingScreen(
    BuildContext context, {
    Doctor? doctor,
    AppointmentModel? appointment,
  }) {
    final doctorId = doctor?.id;
    Widget screen = BottomBar(initialIndex: 1);
    final doctorBookingId = appointment?.id;

    if (doctorId != null && doctorBookingId != null) {
      screen = DoctorRatingScreen2(
        doctorId: doctorId.toInt(),
        bookingId: doctorBookingId.toInt(),
        rating: doctor?.rating ?? 0.0,
        profileImage: doctor?.profileImage,
        doctorName: getLocalizedName(context, doctor),
        specialization: getLocalizedSpecalizedName(context, doctor),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }
}
