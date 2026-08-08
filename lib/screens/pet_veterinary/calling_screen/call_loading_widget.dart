import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class CallLoadingWidget extends StatelessWidget {
  const CallLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.threeArchedCircle(
          size: 33,
          color: PetVeterinaryColors.borderLeftColor,
        ),
        kHeight10,
        Text("Joining channel...".tr()),
      ],
    );
  }
}
