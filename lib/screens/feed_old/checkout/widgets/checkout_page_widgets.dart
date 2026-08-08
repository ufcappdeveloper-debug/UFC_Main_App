import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

Widget radioButton({bool? selected}) {
  return Container(
    margin: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
    color: Colors.transparent,
    child: selected == false
        ? Container(
            color: Colors.transparent,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color.fromRGBO(199, 202, 217, 1)),
              ),
            ),
          )
        : Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              margin: const EdgeInsets.all(6),
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
            ),
          ),
  );
}

Widget checkButton({bool selected = false}) {
  return Container(
    width: 20,
    height: 20,
    padding: EdgeInsets.all(3),
    alignment: Alignment.center,
    margin: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: const Color.fromRGBO(199, 202, 217, 1)),
      color: selected ? primaryColor : Colors.transparent,
    ),
    child: selected
        ? Image.asset(
            'assets/images/global/check.png',
            width: 20,
            height: 20,
            color: Colors.white,
          )
        : null,
  );
}

Widget checkoutTitle(
    {required String title, String? itemCount, EdgeInsets? margin}) {
  return Container(
    margin: margin ?? const EdgeInsets.only(left: 20, right: 20, top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title.tr(),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(30, 51, 84, 1),
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
