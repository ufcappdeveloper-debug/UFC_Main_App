import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

class VehicleNumberWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const VehicleNumberWidget({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: PetVeterinaryShadows.standard2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Top icon + title
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/feed/vehicle.svg',
                width: 18,
                height: 18,
              ),
              const SizedBox(width: 4),
              CustomText(
                text: 'Vehicle Number',
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🔹 TextFormField with floating label and custom styles
          TextFormField(
            controller: controller,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontSize: 16,
            ),
            validator: validator ??
                (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Required";
                  }
                  return null;
                },
            decoration: InputDecoration(
              labelText: "Enter plate number".tr(),
              labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: PetVeterinaryColors.newPetLightGray),
              floatingLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.black87,
              ),
              // Hint as example Saudi plate
              hintText: '1234 ABC'.tr(),
              hintStyle: TextStyle(
                color: PetVeterinaryColors.newPetLightGray,
                fontSize: 13,
              ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: PetVeterinaryColors.newPetLightGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: PetVeterinaryColors.newPetLightGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: PetVeterinaryColors.newPetLightGray),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
