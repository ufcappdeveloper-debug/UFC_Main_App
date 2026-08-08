import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class FeedCustomCouponField extends StatelessWidget {
  final int maxLines;
  final bool? enabled;
  final bool? readOnly;

  final Function()? onTap;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final String? fontFamily;
  const FeedCustomCouponField({
    super.key,
    this.onTap,
    this.enabled,
    this.readOnly,
    this.onChanged,
    this.controller,
    this.suffixIcon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.prefixIcon,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff78b943).withAlpha(20)),
      child: InkWell(
          onTap: onTap,
          child: TextFormField(
              maxLength: 10,
              maxLines: maxLines,
              onChanged: onChanged,
              controller: controller,
              enabled: enabled ?? true,
              keyboardType: keyboardType,
              readOnly: readOnly ?? false,
              cursorColor: Colors.black,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis),
              decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: fontFamily),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: PetVeterinaryColors.mainColorUFC),
                      borderRadius: BorderRadius.circular(10.0)),
                  counterText: '',
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.all(22),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(10.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(10.0))))),
    );
  }
}
