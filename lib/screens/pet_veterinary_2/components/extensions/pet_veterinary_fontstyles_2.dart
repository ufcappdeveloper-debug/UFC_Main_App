import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';

class PetVeterinaryFontstyles2 {
  static TextStyle getBoldStyle(BuildContext context, double size) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    return TextStyle(
      // fontFamily: isEnglish ? 'Poppins' : 'Graphik Arabic',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontWeight: FontWeight.w600,
      fontSize: size,
    );
  }

  static TextStyle getSuperBoldStyle(BuildContext context, double size) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    return TextStyle(
      // fontFamily: isEnglish ? 'Poppins' : 'Graphik Arabic',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontWeight: FontWeight.w700,
      fontSize: size,
    );
  }

  static TextStyle getMediumStyle(BuildContext context, double size) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    return TextStyle(
      // fontFamily: isEnglish ? 'Poppins' : 'Graphik Arabic',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontWeight: FontWeight.w500,
      fontSize: size,
    );
  }

  static TextStyle getRegularStyle(BuildContext context, double size,
      {Color? color, FontWeight weight = FontWeight.w400}) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    return TextStyle(
      // fontFamily: isEnglish ? 'Poppins' : 'Graphik Arabic',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontWeight: weight,
      fontSize: size,
      color: color,
    );
  }

  static TextStyle getLightStyle(BuildContext context, double size,
      {Color? color}) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    return TextStyle(
      // fontFamily: isEnglish ? 'Poppins' : 'Graphik Arabic',
      fontFamily: isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
      fontWeight: FontWeight.w300,
      fontSize: size,
      color: color,
    );
  }

  static const TextStyle manropeRegular14 = TextStyle(
      fontFamily: 'Manrope',
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      fontSize: 14);
}
