import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class SelectLanguageButton extends StatelessWidget {
  const SelectLanguageButton({
    super.key,
    required this.flag,
    required this.title,
    required this.onPressed,
  });
  final String flag;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 0),
            color: const Color.fromRGBO(0, 0, 0, 0.08).withValues(alpha: 0.08),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: primaryColor.withValues(alpha: 0.23),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(flag),
            kWidth10,
            CustomText(
              text: title,
              fontSize: 13,
              notTranslated: true,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
