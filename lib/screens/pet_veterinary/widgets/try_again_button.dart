import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/utils/app_file_picker.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/custom_button_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/doctor_card_2.dart';

enum TryAgainButtonStyle { old, newPet }

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({
    super.key,
    this.icon,
    this.message,
    this.onPressed,
    this.description,
    this.hideButton = false,
    this.messagePadding = const EdgeInsets.symmetric(vertical: 20),
    this.styleType = TryAgainButtonStyle.old,
  });

  final IconData? icon;
  final bool hideButton;
  final String? message;
  final String? description;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry messagePadding;
  final TryAgainButtonStyle styleType;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 48,
              color: styleType == TryAgainButtonStyle.old
                  ? Colors.redAccent
                  : PetVeterinaryColors.newPetMainColorVeterinary,
            ),
          Padding(
            padding: messagePadding,
            child: Text(
              message?.tr() ??
                  (styleType == TryAgainButtonStyle.old
                      ? 'Something went wrong. Please try again.'.tr()
                      : 'Oops, something happened!'.tr()),
              textAlign: TextAlign.center,
              style: styleType == TryAgainButtonStyle.old
                  ? TextStyles.textViewSemiBold15(color: Colors.black)
                  : PetVeterinaryFontstyles2.getRegularStyle(
                      context,
                      13,
                    ),
            ),
          ),
          if (!isStringEmpty(description))
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                description ?? '',
                textAlign: TextAlign.center,
                style: styleType == TryAgainButtonStyle.old
                    ? TextStyles.textViewRegular14()
                        .copyWith(color: Colors.grey)
                    : PetVeterinaryFontstyles2.getRegularStyle(
                        context,
                        13,
                        color: PetVeterinaryColors.newPetLightGray,
                      ),
              ),
            ),
          if (!hideButton && onPressed != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: styleType == TryAgainButtonStyle.old
                  ? CustomButton2(
                      bgColor: PetVeterinaryColors.borderLeftColor,
                      onPressed: onPressed!,
                      child: Text(
                        'Try Again'.tr(),
                        style: TextStyles.textViewRegular15(
                            color: AppColors.white),
                      ),
                    )
                  : CustomPetButton(
                      text: 'Retry'.tr(),
                      onPressed: onPressed!,
                      backgroundColor:
                          PetVeterinaryColors.newPetMainColorVeterinary,
                      textStyle: PetVeterinaryFontstyles2.getRegularStyle(
                        context,
                        13,
                        color: Colors.white,
                      ),
                      borderRadius: 12,
                      horizontalPadding: 20,
                      verticalPadding: 10,
                    ),
            ),
        ],
      ),
    );
  }
}
