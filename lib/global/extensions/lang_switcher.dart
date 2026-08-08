import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';

String drSpecialasation(Doctor doctor, BuildContext context) {
  final specializationEn = doctor.specializationEn?.trim();
  final specializationAr = doctor.specializationAr?.trim();

  if (isEnglish) {
    return (specializationEn?.isNotEmpty ?? false)
        ? specializationEn!
        : (specializationAr?.isNotEmpty ?? false)
            ? specializationAr!
            : '';
  } else {
    return (specializationAr?.isNotEmpty ?? false)
        ? specializationAr!
        : (specializationEn?.isNotEmpty ?? false)
            ? specializationEn!
            : '';
  }
}

/// Dr name
String drName(Doctor doctor, BuildContext context) {
  final nameEn = doctor.nameEn?.trim();
  final nameAr = doctor.nameAr?.trim();

  if (isEnglish) {
    return (nameEn?.isNotEmpty ?? false)
        ? nameEn!
        : (nameAr?.isNotEmpty ?? false)
            ? nameAr!
            : 'Unavailable'.tr();
  } else {
    return (nameAr?.isNotEmpty ?? false)
        ? nameAr!
        : (nameEn?.isNotEmpty ?? false)
            ? nameEn!
            : 'Unavailable'.tr();
  }
}
