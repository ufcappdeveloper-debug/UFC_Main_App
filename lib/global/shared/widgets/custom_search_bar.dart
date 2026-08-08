import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_font_style.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';

class CustomSearchBar extends StatefulWidget {
  double? height;
  double? width;
  FocusNode? myFocusNode;
  TextEditingController? controller;
  String? labelText;
  String? hintText;
  bool? alignLabelWithHint;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  List<TextInputFormatter>? inputFormatters;
  EdgeInsetsGeometry? contentPadding;
  Widget? prefixIcon;
  Widget? suffixIcon;
  EdgeInsets? suffixIconPadding;
  bool readOnly;
  VoidCallback? onTap;
  FocusNode? nodeAfter;
  bool? showError;
  String? title;
  bool? helperTextSize;
  final int? maxLines;
  final bool enabled;
  final bool isExpanded;
  int? maxLength;
  BorderRadius? borderRadius;
  BorderSide? borderSide;
  List<BoxShadow>? boxShadow;
  final Function()? onEditingComplete;
  final Function(String?)? onFieldSubmitted;

  // 🔹 New parameters
  final Color? backgroundColor;
  final double elevation;
  final bool hideBorder;

  @override
  State<StatefulWidget> createState() => _CustomSearchBar();

  CustomSearchBar({
    super.key,
    this.height = 35,
    this.width,
    this.myFocusNode,
    this.controller,
    this.labelText,
    this.hintText,
    this.alignLabelWithHint = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.inputFormatters,
    this.contentPadding,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconPadding,
    this.readOnly = false,
    this.onTap,
    this.nodeAfter,
    this.title,
    this.helperTextSize = false,
    this.maxLines = 1,
    this.enabled = true,
    this.maxLength,
    this.borderRadius,
    this.borderSide,
    this.boxShadow,
    this.isExpanded = false,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.backgroundColor,
    this.elevation = 0,
    this.hideBorder = false,
  });
}

class _CustomSearchBar extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
      borderSide: widget.borderSide ??
          BorderSide(
            width: 1,
            color: widget.hideBorder ? Colors.transparent : Color(0xffD9D9D9),
          ),
    );

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: FocusScope(
        child: Focus(
          onFocusChange: (focus) {},
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              boxShadow: widget.boxShadow ?? [],
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: TextFormField(
              expands: widget.isExpanded,
              onTap: widget.onTap,
              onTapOutside: (val) => FocusScope.of(context).unfocus(),
              maxLength: widget.maxLength,
              obscuringCharacter: "*",
              cursorColor: Colors.grey,
              readOnly: widget.readOnly,
              focusNode: widget.myFocusNode,
              controller: widget.controller,
              style: const TextStyle(fontSize: 12, fontFamily: 'Kanit'),
              autofocus: false,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.inputFormatters,
              maxLines: widget.isExpanded ? null : widget.maxLines,
              enabled: widget.enabled,
              onFieldSubmitted: widget.onFieldSubmitted ?? (value) {},
              onEditingComplete: widget.onEditingComplete ??
                  () {
                    if (widget.nodeAfter != null) {
                      return widget.nodeAfter!.requestFocus();
                    }
                    return FocusScope.of(context).requestFocus(FocusNode());
                  },
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                helperStyle: TextStyle(
                  fontSize: widget.helperTextSize == true ? 0 : 0,
                ),
                hintText: (widget.hintText ?? 'Search').tr(),
                hintStyle: AppFontStyle.getRegularStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  height: 1.2,
                ),
                prefixIcon: widget.prefixIcon ??
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        AppImages.searchIcon,
                        height: 16,
                        width: 16,
                      ),
                    ),
                prefixIconConstraints:
                    const BoxConstraints(maxHeight: 50, maxWidth: 50),
                labelText: widget.labelText,
                labelStyle: const TextStyle(
                  color: Color(0xffe3e3e3),
                ),
                contentPadding:
                    widget.contentPadding ?? const EdgeInsets.only(top: 10),
                fillColor: widget.backgroundColor ?? Colors.white,
                filled: true,
                enabledBorder: border,
                border: border,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: border,
                focusedBorder: border,
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
