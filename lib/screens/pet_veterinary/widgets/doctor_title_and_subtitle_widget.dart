import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';

Widget doctorTitleAndSubtitleWidget({
  required String iconPath,
  required String title,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SvgPicture.asset(
        iconPath,
        width: 16,
        height: 16,
        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: PetVeterinaryFontstyles.poppinsMedium14
                  .copyWith(color: PetVeterinaryColors.customGrayColor2)),
          const SizedBox(height: 4),
          Text(value,
              style: PetVeterinaryFontstyles.poppinsMedium14
                  .copyWith(color: PetVeterinaryColors.customBlackColor2)),
        ],
      ),
    ],
  );
}
