import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_functions.dart';

Widget radioButton({bool? selected}) {
  return Container(
      margin: EdgeInsets.only(
          top: 5, bottom: 5, right: isArOrUr ? 0 : 10, left: isArOrUr ? 10 : 0),
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
          : SvgPicture.asset(
              'assets/svg/global/check.svg',
              height: 24,
            ));
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

Widget checkButtonV2({
  bool selected = false,
  required ValueChanged<bool> onChanged,
}) {
  return CupertinoSwitch(
    inactiveTrackColor: Colors.grey[200],
    activeTrackColor: primaryColor,
    value: selected,
    onChanged: onChanged,
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
          // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
          fontFamily:
              isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
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

Directionality sadadUserInfoWidget(BuildContext context,
    SadadUserInfo? sadadUserData, BoxConstraints constraints,
    {VoidCallback? onPressed}) {
  return Directionality(
    textDirection: ui.TextDirection.ltr,
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: sadadUserData?.customerFullName ?? "User Name",
                fontWeight: FontWeight.w500,
                color: isSadadInfoExist(sadadUserData) ? null : Colors.grey,
              ),
              kHeight10,
              CustomText(
                text: sadadIdNumberFormate(sadadUserData) ?? "ID Number",
                fontWeight: FontWeight.w500,
                color: isSadadInfoExist(sadadUserData) ? null : Colors.grey,
              ),
              kHeight10,
              CustomText(
                text: sadadPhoneFormat(sadadUserData) ?? "Phone Number",
                fontWeight: FontWeight.w500,
                color: isSadadInfoExist(sadadUserData) ? null : Colors.grey,
              ),
            ],
          ),
          TextButton(
            onPressed: onPressed,
            child: CustomText(
              text: sadadUserData == null ? "Add" : "Edit",
              fontWeight: FontWeight.w500,
              color: onPressed == null
                  ? Color.fromARGB(255, 236, 236, 236)
                  : const Color(0xff78B833),
            ),
          )
        ],
      ),
    ),
  );
}
