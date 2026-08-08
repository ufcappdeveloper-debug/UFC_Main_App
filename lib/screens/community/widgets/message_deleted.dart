import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

Widget messageDeleted({Color? color, EdgeInsetsGeometry? padding}) {
  return Container(
    // width: 200,
    decoration: BoxDecoration(
      borderRadius: boRadius(10),
      color: color ?? Colors.transparent,
    ),
    padding: padding ?? ksymmetric(10, 6),
    child: Row(
      children: [
        Icon(
          Icons.block,
          color: AppColors.grey,
          size: 15,
        ),
        kWidth5,
        CustomText(
          text: 'This message was deleted',
          fontSize: 12,
          color: AppColors.grey,
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
        ),
      ],
    ),
  );
}
