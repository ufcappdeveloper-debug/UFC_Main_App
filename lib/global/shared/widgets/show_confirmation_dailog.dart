import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

import '../../extensions/app_colors.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  bool fromFarm = false,
  bool isFromVet = false,
  Color? color,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: CustomText(
        text: title,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      content: CustomText(text: content),
      contentPadding:
          const EdgeInsets.only(top: 5, left: 25, right: 25, bottom: 20),
      titlePadding:
          const EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 0),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (fromFarm) {
              return Navigator.of(dialogContext, rootNavigator: true)
                  .pop(false);
            } else {
              return Navigator.of(dialogContext).pop(false);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: color ?? (isFromVet
                ? PetVeterinaryColors.newPetMainColorVeterinary
                : (fromFarm ? AppColors.farmColor : primaryColor)),
            foregroundColor: Colors.white,
          ),
          child: CustomText(
            text: "No".tr(),
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            if (fromFarm) {
              return Navigator.of(dialogContext, rootNavigator: true).pop(true);
            } else {
              return Navigator.of(dialogContext).pop(true);
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: color ?? (isFromVet
                ? PetVeterinaryColors.newPetMainColorVeterinary
                : (fromFarm ? AppColors.farmColor : primaryColor)),
            backgroundColor: Colors.white,
          ),
          child: CustomText(
            text: "Yes".tr(),
            fontSize: 14,
            color: color ?? (isFromVet
                ? PetVeterinaryColors.newPetMainColorVeterinary
                : (fromFarm ? AppColors.farmColor : primaryColor)),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
