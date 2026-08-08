import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class EditProfileTextField extends StatelessWidget {
  const EditProfileTextField({
    super.key,
    this.suffix,
    this.maxLength,
    this.focusNode,
    this.formatter,
    this.validator,
    this.keyboardType,
    required this.text,
    this.textInputAction,
    this.readOnly = true,
    this.autofocus = false,
    this.onEditingComplete,
    required this.hintText,
    required this.controller,
    this.obscureText,
  });
  final String text;
  final bool readOnly;
  final int? maxLength;
  final Widget? suffix;
  final bool autofocus;
  final String hintText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Function()? onEditingComplete;
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? formatter;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            flex: 1,
            child: CustomText(
                text: text.tr(),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF898989))),
        Expanded(
            flex: 2,
            child: Padding(
                padding: const EdgeInsets.only(left: 22),
                child: TextFormField(
                    obscureText: obscureText ?? false,
                    readOnly: readOnly,
                    maxLength: maxLength,
                    autofocus: autofocus,
                    focusNode: focusNode,
                    validator: validator,
                    controller: controller,
                    cursorColor: primaryColor,
                    inputFormatters: formatter,
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    keyboardType: keyboardType ?? TextInputType.text,
                    textInputAction: textInputAction ?? TextInputAction.next,
                    decoration: InputDecoration(
                        isDense: true,
                        counterText: "",
                        hintText: hintText.tr(),
                        suffix: readOnly ? suffix : null,
                        hintStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Kanit',
                            color: Color(0xFF898989),
                            fontWeight: FontWeight.w300),
                        border: readOnly
                            ? InputBorder.none
                            : const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFFE1E1E1))),
                        enabledBorder: readOnly
                            ? InputBorder.none
                            : const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFFE1E1E1))),
                        focusedBorder: readOnly
                            ? InputBorder.none
                            : const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: primaryColor))),
                    onEditingComplete: onEditingComplete ??
                        () => FocusManager.instance.primaryFocus?.nextFocus())))
      ]);
}
