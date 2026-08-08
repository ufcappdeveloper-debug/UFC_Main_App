import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

InputDecoration sadadEditFieldDecoration(
    {String? labelText, Widget? prefixIcon, String? hintText}) {
  return InputDecoration(
    isDense: true,
    hintText: hintText,
    labelText: labelText,
    prefixIcon: prefixIcon,
    hintStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'Kanit',
        color: Color(0xFFB6B6B6),
        fontWeight: FontWeight.w400),
    contentPadding: const EdgeInsets.all(0),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(width: 1, color: Color(0xFFE9E9E9))),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(width: 1, color: Color(0xFFE9E9E9)),
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(width: 1, color: primaryColor)),
  );
}
