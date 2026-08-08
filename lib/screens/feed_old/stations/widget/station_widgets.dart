import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

Future<bool> showUpdateStationDialog(BuildContext context) async {
  bool updatePref = false;
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
              "Update Station".tr(),
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
                  "Are you sure you want to update your preferred station? If you proceed, your cart will also be cleared."
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
                    updatePref = true;
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: CustomText(
                    text: "Yes".tr(),
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                kWidth10,
                TextButton(
                  onPressed: () {
                    updatePref = false;
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    backgroundColor: Colors.white,
                  ),
                  child: CustomText(
                    text: "No".tr(),
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
  return updatePref;
}
