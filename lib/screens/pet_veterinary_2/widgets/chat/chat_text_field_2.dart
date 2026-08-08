import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

class ChatTextField2 extends StatelessWidget {
  const ChatTextField2({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onEditingComplete,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode, // Set the focusNode here
      textAlign: TextAlign.start, // Centers both input and hint
      cursorColor: AppColors.dateSelectorActiveTextColor,
      onEditingComplete: onEditingComplete,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      onTapOutside: (val) {
        // Only unfocus if the TextField is empty
        if (controller.text.isEmpty) {
          FocusScope.of(context).unfocus();
        }
      },
      style: PetVeterinaryFontstyles.poppinsRegularTextStyle14
          .copyWith(fontSize: 13),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        filled: true,
        hintText: 'Write your message....'.tr(),
        fillColor: PetVeterinaryColors.customLightBackground,
        hintStyle: PetVeterinaryFontstyles2.getLightStyle(context, 13)
            .copyWith(color: PetVeterinaryColors.newPetDarkGray),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
