import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

Row pullRefreshBody(
    {IconData? icon, required String text, Widget? iconWidget}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      iconWidget ??
          Icon(
            icon,
            color: Colors.grey.withValues(alpha: 0.5),
            size: 19,
          ),
      kWidth10,
      CustomText(
        text: text,
        fontSize: 14,
        color: Colors.grey.withValues(alpha: 0.5),
      ),
    ],
  );
}

const appBarShadow = BoxShadow(
    blurRadius: 20,
    spreadRadius: 0,
    offset: Offset(0, 4),
    color: Color.fromRGBO(0, 0, 0, 0.08));

Future<bool> showBtmSheet(BuildContext context, Widget child) async =>
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => child,
    ) ??
    false;
