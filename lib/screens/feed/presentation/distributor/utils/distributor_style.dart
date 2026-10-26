import 'package:flutter/material.dart';

import '../../../../../global/util/lang/langauge_manager.dart';

/// Design tokens for the distributor screens (Flutter Mobile App Design, Oct 2026).
class DistributorStyle {
  static const Color green = Color(0xff78B833);
  static const Color tabGreen = Color(0xff78B943);
  static const Color yellow = Color(0xFFF7D66D);
  static const Color text = Color(0xDE000000);
  static const Color textSecondary = Color(0xFF44444F);
  static const Color muted = Color(0xFFCFCFCF);
  static const Color priceGrey = Color(0xFF7C7C7C);
  static const Color error = Color(0xFFFF3B30);
  static const Color greenTint = Color(0x1F78B833);
  static const Color yellowTint = Color(0x1AF7D66D);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
        color: Color(0x14000000),
        offset: Offset(0, 2),
        blurRadius: 8,
        spreadRadius: .5),
    BoxShadow(
        color: Color(0x0A000000),
        offset: Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 1),
  ];

  static BoxDecoration card({double radius = 18, Color color = Colors.white}) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: cardShadow,
      );

  static const String font = 'Alexandria';

  static TextStyle style(
          {double size = 13,
          FontWeight weight = FontWeight.w400,
          Color color = text}) =>
      TextStyle(
          fontFamily: font, fontSize: size, fontWeight: weight, color: color);
}

/// Picks the `_en` / `_ar` / `_ur` value for the current app language,
/// falling back to English.
String localized(String? en, String? ar, [String? ur]) {
  final locale = LanguageManager.locale;
  String? value;
  if (locale == 'ar') value = ar;
  if (locale == 'ur') value = ur;
  if (value == null || value.trim().isEmpty) value = en;
  if (value == null || value.trim().isEmpty) value = ar;
  return value ?? '';
}
