import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class NoStockContainer extends StatelessWidget {
  const NoStockContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 16),
        child: Container(
          height: 45,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: PetVeterinaryColors.yellowBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Unavailable", fontSize: 15),
              Image.asset(
                AppPngImages.noStockPng,
                height: 26,
                width: 26,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ));
  }
}
