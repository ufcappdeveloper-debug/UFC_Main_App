import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

@immutable
class CustomText extends StatelessWidget {
  CustomText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.fontSize = 12,
    this.textHeightBehavior,
    this.height,
    this.textAlign,
    this.maxLines,
    this.fontFamily,
    this.decoration,
    this.decorationColor,
    this.fontStyle,
    this.overflow,
    this.shadows,
    this.notTranslated = false,
    this.textStyle,
  });
  final String text;
  final bool notTranslated;
  FontWeight? fontWeight = FontWeight.normal;
  Color? color;
  double? fontSize;
  TextHeightBehavior? textHeightBehavior;
  double? height;
  TextAlign? textAlign;
  int? maxLines;
  TextDecoration? decoration;
  String? fontFamily;
  FontStyle? fontStyle;
  TextOverflow? overflow;
  List<Shadow>? shadows;
  final Color? decorationColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      notTranslated ? text : text.tr(),
      maxLines: maxLines,
      style: textStyle ??
          TextStyle(
            color: color,
            height: height,
            shadows: shadows,
            fontSize: fontSize,
            fontStyle: fontStyle,
            fontWeight: fontWeight,
            fontFamily: fontFamily ??
                (isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic),
            decoration: decoration ?? TextDecoration.none,
            decorationColor: decorationColor,
            overflow: overflow,
          ),
      overflow: overflow,
      textAlign: textAlign,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
