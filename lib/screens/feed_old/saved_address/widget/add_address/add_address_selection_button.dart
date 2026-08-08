import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

class AddAddressSelectionButton extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onPressed;
  final bool selected;
  const AddAddressSelectionButton(
      {super.key,
      required this.image,
      required this.title,
      required this.onPressed,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(77, 36),
        backgroundColor: selected ? const Color(0xFFFFC53F) : primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      onPressed: onPressed,
      icon: SvgPicture.asset(image),
      label: Text(
        title.tr(),
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }
}
