import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';

class CommentsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;

  const CommentsTextField({
    super.key,
    required this.controller,
    this.placeholder = 'Other (write in 10 words)',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: placeholder,
        labelStyle: PetVeterinaryFontstyles.kanitMediumTextStyle12_2
            .copyWith(color: Colors.black),
        hintText: 'Write here...',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: PetVeterinaryColors.customSeparatorOpaque),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: PetVeterinaryColors.customSeparatorOpaque),
        ),
      ),
    );
  }
}
