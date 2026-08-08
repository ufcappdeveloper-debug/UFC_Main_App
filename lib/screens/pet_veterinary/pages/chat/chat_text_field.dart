import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
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
      textAlign: TextAlign.center, // Centers both input and hint
      cursorColor: AppColors.dateSelectorActiveTextColor,
      onEditingComplete: onEditingComplete,
      textInputAction: TextInputAction.done,
      onTapOutside: (val) {
        // Only unfocus if the TextField is empty
        if (controller.text.isEmpty) {
          FocusScope.of(context).unfocus();
        }
      },
      style: PetVeterinaryFontstyles.poppinsRegularTextStyle14
          .copyWith(fontSize: 13),
      maxLines: 1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        filled: true,
        hintText: 'Type your problems'.tr(),
        fillColor: AppColors.dateSelectorBgColor,
        hintStyle: PetVeterinaryFontstyles.poppinsRegularTextStyle14
            .copyWith(fontSize: 13),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
