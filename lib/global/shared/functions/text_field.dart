import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

InputDecoration customTextFieldDecoration(
        {String? hintText,
        Widget? prefixIcon,
        TextStyle? hintStyle,
        required double radius,
        required Color borderColor,
        EdgeInsetsGeometry? contentPadding}) =>
    InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(width: 1, color: borderColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(width: 1, color: borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(width: 1, color: primaryColor)));
