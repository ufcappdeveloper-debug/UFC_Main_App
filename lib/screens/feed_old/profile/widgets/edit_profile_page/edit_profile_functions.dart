import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String? editProfileFormatDate(
    {required String inFormate,
    required String outFormate,
    required String? inputDate}) {
  if (inputDate == null || inputDate.isEmpty) return null;

  try {
    final inputFormat = DateFormat(inFormate, 'en');
    final outputFormat = DateFormat(outFormate, 'en');
    final time = inputFormat.parse(inputDate);
    return outputFormat.format(time);
  } catch (e) {
    debugPrint(e.toString());
  }

  return null;
}
