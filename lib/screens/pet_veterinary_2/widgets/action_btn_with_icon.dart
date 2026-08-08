import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

class ActionButtonWithIcon extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOutlined;
  final String iconPath;

  const ActionButtonWithIcon({
    super.key,
    required this.label,
    required this.onTap,
    required this.iconPath,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor = PetVeterinaryColors.newPetMainColorVeterinary;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
          height: 54,
          decoration: BoxDecoration(
            color: isOutlined ? Colors.white : mainColor,
            border: Border.all(color: mainColor, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: isOutlined ? mainColor : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label.tr(),
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 14)
                    .copyWith(color: isOutlined ? mainColor : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
