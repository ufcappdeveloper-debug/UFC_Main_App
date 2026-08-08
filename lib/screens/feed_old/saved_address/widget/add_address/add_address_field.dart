import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class AddAddressField extends StatelessWidget {
  final bool enabled;
  final String heading;
  final TextInputAction action;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix; // for country code or icon

  const AddAddressField({
    super.key,
    this.validator,
    this.enabled = true,
    this.inputFormatters,
    required this.heading,
    required this.controller,
    this.action = TextInputAction.next,
    this.keyboardType = TextInputType.name,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          cursorColor: primaryColor,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: action,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            fontSize: 12, // value text size
            fontWeight: FontWeight.w500, // value text weight
            color: Colors.black, // value text color
            fontFamily: "Kanit",
          ),
          validator: validator ??
                  (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return "required".tr();
                }
                return null;
              },
          decoration: InputDecoration(
            // 👇 replace labelText with a widget-based label
            label: CustomText(
              text: heading,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: const Color(0xFFCFCECE),
            ),
            prefix: prefix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gapPadding: 15,
              borderSide: BorderSide(color: Color(0xFFEAEAEA)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
