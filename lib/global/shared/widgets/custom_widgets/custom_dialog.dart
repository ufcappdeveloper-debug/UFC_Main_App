import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

Future<bool> customDialog(BuildContext context, String message) async =>
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: CustomText(
          text: message,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        titlePadding:
            const EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 0),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: CustomText(
              text: "No".tr(),
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
              backgroundColor: Colors.white,
            ),
            child: CustomText(
              text: "Yes".tr(),
              fontSize: 14,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
