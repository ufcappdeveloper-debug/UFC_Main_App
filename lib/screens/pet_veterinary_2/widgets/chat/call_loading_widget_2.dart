import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

class CallLoadingWidget2 extends StatelessWidget {
  const CallLoadingWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.threeArchedCircle(
          size: 33,
          color: PetVeterinaryColors.newPetMainColorVeterinary,
        ),
        kHeight10,
        Text(
          "Joining channel...".tr(),
          style: PetVeterinaryFontstyles2.getRegularStyle(context, 15)
              .copyWith(color: PetVeterinaryColors.newPetDarkGray),
        ),
      ],
    );
  }
}
