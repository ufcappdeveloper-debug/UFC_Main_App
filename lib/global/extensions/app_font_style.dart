import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class AppFontStyle {
  static TextStyle getRegularStyle({
    double? fontSize,
    Color? color,
    FontWeight weight = FontWeight.w400,
    double? height,
    TextDecoration? decoration,
    double? decorationThickness, // new param
  }) {
    return TextStyle(
      fontFamily: (isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic),
      fontWeight: weight,
      height: height,
      fontSize: fontSize ?? 13,
      color: color,
      overflow: TextOverflow.ellipsis,
      decoration: decoration,
      decorationThickness: decorationThickness, // forward it
    );
  }

  static TextStyle getMediumStyle({
    double? fontSize,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? height,
  }) {
    return TextStyle(
      fontFamily: isArOrUr ? 'Font/Arabic Font' : 'Poppins',
      fontWeight: weight,
      height: height,
      fontSize: fontSize ?? 13,
      color: color,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle getRegularStyleV2({
    double? fontSize,
    Color? color,
    FontWeight weight = FontWeight.w400,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontWeight: weight,
      height: height,
      fontSize: fontSize ?? 13,
      color: color,
      overflow: TextOverflow.ellipsis,
      decoration: decoration,
    );
  }

  static TextStyle getMediumStyleV2({
    double? fontSize,
    Color? color,
    FontWeight weight = FontWeight.w500,
    double? height,
  }) {
    return TextStyle(
      // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontWeight: weight,
      height: height,
      fontSize: fontSize ?? 13,
      color: color,
      overflow: TextOverflow.ellipsis,
    );
  }
}
