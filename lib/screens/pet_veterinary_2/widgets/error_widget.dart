import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

Center errorWidget(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8, // limit width
        ),
        child: Text(
          "Oops something went wrong please try again later".tr(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: PetVeterinaryFontstyles2.getRegularStyle(context, 13).copyWith(
            color: PetVeterinaryColors.newPetDarkGray,
          ),
        ),
      ),
    ),
  );
}
