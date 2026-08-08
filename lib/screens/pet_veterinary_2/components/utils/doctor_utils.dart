// lib/utils/doctor_utils.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';

class DoctorUtils {
  static bool _isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static String doctorSpecialization(Doctor? doctor) {
    if (doctor == null) return 'Unavailable'.tr();

    if (isEnglish) {
      return !_isNullOrEmpty(doctor.specializationEn)
          ? doctor.specializationEn!
          : (!_isNullOrEmpty(doctor.specializationAr)
              ? doctor.specializationAr!
              : 'Unavailable'.tr());
    }

    return !_isNullOrEmpty(doctor.specializationAr)
        ? doctor.specializationAr!
        : (!_isNullOrEmpty(doctor.specializationEn)
            ? doctor.specializationEn!
            : 'Unavailable'.tr());
  }

  static String doctorName(Doctor? doctor) {
    if (doctor == null) return '';

    if (isEnglish) {
      return !_isNullOrEmpty(doctor.nameEn)
          ? doctor.nameEn!
          : (doctor.nameAr ?? '');
    }
    return !_isNullOrEmpty(doctor.nameAr)
        ? doctor.nameAr!
        : (doctor.nameEn ?? '');
  }

  static String getTranslatedReviewText(String? reviewText) {
    if (reviewText == null || reviewText.isEmpty) {
      return 'No review provided'.tr();
    }

    if (reviewText.trim().toLowerCase() == 'no comments') {
      return 'No comments'.tr();
    }

    return reviewText;
  }

  static String getTranslatedStatusText(String? statusText) {
    if (statusText == null || statusText.isEmpty) {
      return 'Status unavailable'.tr();
    }

    if (statusText.trim().toLowerCase() == 'pending') {
      return 'Pending'.tr();
    }

    return statusText;
  }

  static String doctorExp(Doctor? doctor) {
    if (doctor == null) return '';

    if (isEnglish) {
      return !_isNullOrEmpty(doctor.experience)
          ? doctor.experience!
          : (doctor.experienceAr ?? '');
    }
    return !_isNullOrEmpty(doctor.experienceAr)
        ? doctor.experienceAr!
        : (doctor.experience ?? '');
  }

  static String aboutDoctor(Doctor? doctor) {
    if (doctor == null) return 'Unavailable'.tr();

    if (isEnglish) {
      return !_isNullOrEmpty(doctor.aboutEn)
          ? doctor.aboutEn!
          : (!_isNullOrEmpty(doctor.aboutAr)
              ? doctor.aboutAr!
              : 'Unavailable'.tr());
    }
    return !_isNullOrEmpty(doctor.aboutAr)
        ? doctor.aboutAr!
        : (!_isNullOrEmpty(doctor.aboutEn)
            ? doctor.aboutEn!
            : 'Unavailable'.tr());
  }

  static bool isArabicText(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
