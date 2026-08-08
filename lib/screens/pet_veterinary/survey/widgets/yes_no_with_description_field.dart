import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/comments_text_field.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/selectable_check_box_tile.dart';

class YesNoWithDescriptionField extends StatelessWidget {
  final bool isYesSelected;
  final bool isNoSelected;
  final VoidCallback onYesTap;
  final VoidCallback onNoTap;
  final TextEditingController controller;
  final ValueChanged<String>? onTextChanged;

  const YesNoWithDescriptionField({
    super.key,
    required this.isYesSelected,
    required this.isNoSelected,
    required this.onYesTap,
    required this.onNoTap,
    required this.controller,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(right: 16, left: 16, bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: SelectableCheckboxTile(
                    label: 'Yes',
                    isSelected: isYesSelected,
                    onTap: onYesTap,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: SelectableCheckboxTile(
                    label: 'No',
                    isSelected: isNoSelected,
                    onTap: onNoTap,
                  ),
                ),
              ],
            )),
        const SizedBox(height: 24),
        const Text('If yes, please describe (writing 10 words)',
            style: PetVeterinaryFontstyles.poppinsRegularTextStyle13),
        const SizedBox(height: 16),
        Padding(
            padding: EdgeInsets.only(right: 40),
            child: CommentsTextField(
              controller: controller,
              onChanged: onTextChanged,
            )),
      ],
    );
  }
}
