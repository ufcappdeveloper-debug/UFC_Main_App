import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

Future<void> showClearProductDialog(BuildContext context,
    {Widget? message, Function()? yesPressed}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Warning!".tr(),
              style: const TextStyle(
                fontSize: 14,
                color: primaryColor,
                fontFamily: 'Lexend Deca',
                fontWeight: FontWeight.bold,
              ),
            ),
            kHeight5,
            message ??
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: 'Unsaved data!'.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text: " You'll lose changes. Continue anyway?".tr()),
                    ],
                  ),
                ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                kWidth10,
                TextButton(
                  onPressed: yesPressed ??
                      () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
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
          ],
        ),
      ),
    ),
  );
}

Future<bool> showDeleteProfileDialog(BuildContext context) async {
  bool deleteAccount = false;
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Delete Account".tr(),
              style: const TextStyle(
                fontSize: 14,
                color: primaryColor,
                fontFamily: 'Lexend Deca',
                fontWeight: FontWeight.bold,
              ),
            ),
            kHeight5,
            CustomText(
              text:
                  "Are you sure you want to delete your account? If you delete account, you will permanently lose your data."
                      .tr(),
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    deleteAccount = false;
                    Navigator.pop(context);
                  },
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
                kWidth10,
                TextButton(
                  onPressed: () {
                    deleteAccount = true;
                    Navigator.pop(context);
                  },
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
          ],
        ),
      ),
    ),
  );
  return deleteAccount;
}
