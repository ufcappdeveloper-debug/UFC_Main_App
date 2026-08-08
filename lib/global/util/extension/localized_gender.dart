import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

String localizedGender(BuildContext context, String? gender) {
  if (gender == null || gender.isEmpty) return '';
  final lower = gender.toLowerCase();

  if (!isEnglish) {
    if (lower == 'male') return 'ذكر';
    if (lower == 'female') return 'أنثى';
  } else {
    if (lower == 'ذكر') return 'Male';
    if (lower == 'أنثى') return 'Female';
  }

  return gender;
}
