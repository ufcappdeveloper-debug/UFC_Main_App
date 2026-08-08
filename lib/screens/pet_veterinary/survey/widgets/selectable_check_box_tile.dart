import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';

class SelectableCheckboxTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableCheckboxTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 25,
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: isSelected
                    ? null
                    : Border.all(
                        color: PetVeterinaryColors.customSeparatorOpaque,
                        width: 2,
                      ),
                borderRadius: BorderRadius.circular(4),
                color: isSelected
                    ? PetVeterinaryColors.borderLeftColor
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
            Expanded(
              child: Text(
                label,
                style: PetVeterinaryFontstyles.kanitMediumTextStyle14_2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
