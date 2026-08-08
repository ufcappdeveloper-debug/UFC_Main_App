import 'package:flutter/material.dart';

class CustomCouponField extends StatelessWidget {
  final int maxLines;
  final bool? enabled;
  final bool? readOnly;
  final String labelText;
  final Function()? onTap;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  const CustomCouponField({
    super.key,
    this.onTap,
    this.enabled,
    this.readOnly,
    this.onChanged,
    this.controller,
    this.suffixIcon,
    this.maxLines = 1,
    required this.labelText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 35),
        // padding: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(250, 250, 250, 1)),
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
                    counterText: '',
                    suffixIcon: suffixIcon,
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.all(16),
                    labelText: labelText,
                    labelStyle: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0))))));
  }
}
