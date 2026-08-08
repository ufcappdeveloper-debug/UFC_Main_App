import 'package:flutter/material.dart';

import 'custom_widgets/custom_text.dart';

Widget checkoutTitle({
  required String title,
  String? itemCount,
  EdgeInsets? margin,
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
  String? fontFamily,
  
}) {
  return Container(
    margin: margin ?? const EdgeInsets.only(left: 15, right: 20, top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontFamily: fontFamily,
          text: title,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: color ?? const Color.fromRGBO(30, 51, 84, 1),
        ),
        itemCount != null
            ? CustomText(
                text: itemCount,
                fontWeight: FontWeight.w300,
                color: const Color.fromRGBO(153, 153, 153, 1))
            : const SizedBox.shrink(),
      ],
    ),
  );
}
