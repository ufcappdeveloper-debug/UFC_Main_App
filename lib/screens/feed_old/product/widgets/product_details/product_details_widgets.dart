import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

Row iconAndLabel(
    {required String iconPath, required String text, double width = 10}) {
  return Row(
    children: [
      Image.asset(iconPath, height: 18),
      SizedBox(width: width),
      Flexible(
        child: CustomText(
          text: text,
          maxLines: 2,
          fontWeight: FontWeight.w300,
          overflow: TextOverflow.clip,
        ),
      )
    ],
  );
}
