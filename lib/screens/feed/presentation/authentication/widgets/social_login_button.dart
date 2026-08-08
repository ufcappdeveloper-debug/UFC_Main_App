import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

InkWell socialLoginButton({
  required Function() onTap,
  String? iconPath,
  Widget? icon,
  required String title,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 42,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? SvgPicture.asset(iconPath!),
          const SizedBox(width: 15),
          CustomText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    ),
  );
}
