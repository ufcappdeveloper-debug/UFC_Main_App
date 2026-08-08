import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

class SadadEditTextField extends StatelessWidget {
  const SadadEditTextField({
    super.key,
    this.maxLength,
    this.validator,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.isDone = false,
    this.inputFormatters,
    required this.phoneController,
  });
  final bool isDone;
  final int? maxLength;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController phoneController;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 41, vertical: 5),
        child: TextFormField(
          focusNode: focusNode,
          maxLength: maxLength,
          decoration: decoration,
          cursorColor: primaryColor,
          keyboardType: keyboardType,
          controller: phoneController,
          inputFormatters: inputFormatters,
          onEditingComplete: isDone
              ? () => FocusManager.instance.primaryFocus?.unfocus()
              : () => FocusManager.instance.primaryFocus?.nextFocus(),
          textInputAction: isDone ? TextInputAction.done : TextInputAction.go,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: "Kanit",
            fontWeight: FontWeight.w500,
          ),
          validator: validator ??
              (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return "required";
                }
                return null;
              },
        ),
      ),
    );
  }
}
