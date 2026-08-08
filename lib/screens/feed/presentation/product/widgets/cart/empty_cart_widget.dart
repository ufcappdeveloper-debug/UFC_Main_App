import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';

class EmptyCartWidget extends StatelessWidget {
  final String text;
  final String imagePath; // path to your basket image
  final VoidCallback onButtonPressed;
  final String buttonText;

  const EmptyCartWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onButtonPressed,
    this.buttonText = "Go Shopping",
  });

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = primaryColor;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 237,
            height: 172,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          CustomText(
            fontWeight: FontWeight.w500,
            text: text,
            fontSize: 16,
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: onButtonPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              height: 37,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                buttonText.tr(),
                style: PetVeterinaryFontstyles2.getRegularStyle(context, 14)
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
