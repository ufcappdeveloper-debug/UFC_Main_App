import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.margin,
    this.nodeAfter,
    this.focusNode,
    this.onChanged,
    this.labelText,
    this.validation,
    this.prefixIcon,
    this.errorStyle,
    this.borderRadius,
    this.textInputType,
    this.inputTextColor,
    this.controller,
    this.inputFormatters,
    this.textInputAction,
    this.autoFocus = false,
    this.fillColor = Colors.white,
    this.fillColor1,
    this.labelColor = Colors.white,
    this.cursorColor = Colors.white,
    this.contentPadding = const EdgeInsets.all(15),
    this.obscureText,
    this.suffixIcon,
    this.borderColor,
    this.suffixIconCons,
    this.prefixIconCons,
    this.hint,
    this.onTap,
    this.width,
    this.maxLength,
    this.counterText,
    this.maxLines,
    this.readOnly = false,
  });

  final Color fillColor;
  final Color? fillColor1;
  final bool? autoFocus;
  final String? labelText;
  final Color? labelColor;
  final Color? cursorColor;
  final Widget? prefixIcon;
  final EdgeInsets? margin;
  final FocusNode? nodeAfter;
  final FocusNode? focusNode;
  final TextStyle? errorStyle;
  final Color? inputTextColor;
  final BorderRadius? borderRadius;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validation;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Color? borderColor;
  final BoxConstraints? suffixIconCons;
  final BoxConstraints? prefixIconCons;
  final String? hint;
  final Function()? onTap;
  final double? width;
  final int? maxLength;
  final int? maxLines;
  final String? counterText;
  final bool readOnly;
  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: textInputType == TextInputType.phone ? 
        TextDirection.ltr : isArOrUr ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          width: width,
          margin: margin,
          child: TextFormField(
            readOnly: readOnly,
            onTap: onTap,
            maxLength: maxLength,
           // maxLines: maxLines,
        textAlign: textInputType == TextInputType.phone ? TextAlign.left :
         isArOrUr ? TextAlign.right : TextAlign.left,
            obscureText: obscureText ?? false,
            onTapOutside: (val) => FocusScope.of(context).unfocus(),
            onEditingComplete: () {
              if (nodeAfter != null) {
                return nodeAfter!.requestFocus();
              }
              return FocusScope.of(context).requestFocus(FocusNode());
            },
            onChanged: onChanged,
            validator: validation,
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            cursorColor: cursorColor,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            style: TextStyle(color: inputTextColor ?? Colors.white),
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint?.tr(),
              counterText: counterText,
              hintStyle: TextStyle(
                color: textGrey,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
              suffixIcon: suffixIcon,
              suffixIconConstraints: suffixIconCons,
              prefixIconConstraints: prefixIconCons,
              filled: true,
              labelText: labelText,
              prefixIcon: prefixIcon,
              errorStyle: errorStyle,
              contentPadding: contentPadding,
              fillColor: fillColor1 ?? fillColor.withValues(alpha: 0.2),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelStyle: TextStyle(
                color: labelColor, fontSize: 18),
              border: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.white.withValues(alpha: 0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.white.withValues(alpha: 0.1),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.white.withValues(alpha: 0.1),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
        ),
      );
}
