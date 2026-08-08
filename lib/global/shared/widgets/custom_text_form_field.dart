import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';

import 'custom_widgets/custom_text.dart';

class CustomFormField extends StatefulWidget {
  CustomFormField({
    super.key,
    this.required = false,
    required this.isArabic,
    this.labelText,
    this.hintText,
    this.onTap,
    this.onTapDelete,
    this.fileExists = false,
    this.showError,
    this.disabled = false,
    this.nodeAfter,
    this.upload = false,
    this.readOnly = false,
    this.file,
    this.onChanged,
    this.onEditingComplete,
    this.inputFormatters,
    this.controller,
    this.confirmPasscontroller,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.type,
    this.fillColor,
    this.hintColor,
    this.borderColor = primaryGrey,
    this.textColor = Colors.black,
    this.textAlign,
    this.keyboardType,
    this.textInputAction,
    this.suffixIconPadding,
    this.centerTitles = false,
    this.height = 40,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.expands = false,
    this.validator,
    this.phoneNumberPrefix,
    this.contentPadding,
    this.prefix,
    this.suffix,
    this.helperTextSize = false,
    this.fontSize,
    this.useLabel = true,
    this.enableOnTap = false,
    this.isFillColor = false,
    this.formBorderColor = primaryGrey,
    this.formBorderRadius,
    this.hintTextstyle,
    this.minHeight,
    this.isContentPadding = false,
  });

  bool required;
  bool isFillColor;
  bool isArabic;
  Color formBorderColor;
  double? formBorderRadius;
  String? headerText;
  String? labelText;
  String? hintText;
  FocusNode? nodeAfter;
  VoidCallback? onTap;
  Function()? onTapDelete;
  Function(String)? onChanged;
  Function()? onEditingComplete;
  bool? showError;
  List<TextInputFormatter>? inputFormatters;

  bool disabled;
  bool? upload;
  File? file;
  bool fileExists;
  bool readOnly;
  TextEditingController? controller;
  final TextEditingController? confirmPasscontroller;
  TextStyle? hintTextstyle;

  FocusNode? focusNode;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Widget? phoneNumberPrefix;
  Color? fillColor;
  Color? textColor;
  Color? hintColor;
  Color borderColor;
  String? type;
  TextAlign? textAlign;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  bool centerTitles;
  EdgeInsets? suffixIconPadding;
  double? height;
  int? maxLength;
  int? maxLines;
  int? minLines;
  bool expands;
  FormFieldValidator<String>? validator;
  EdgeInsetsGeometry? contentPadding;
  Widget? prefix;
  Widget? suffix;
  bool? helperTextSize;
  double? fontSize;
  bool useLabel;
  bool enableOnTap;
  bool isContentPadding;
  double? minHeight;
  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  String dialCode = "971";
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.minHeight ?? 52.0,
        maxHeight: 200.0,
      ),
      decoration: BoxDecoration(
          color: widget.fillColor ?? Colors.white,
          border: Border.all(color: widget.borderColor, width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !widget.enableOnTap
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Directionality(
                            textDirection: widget.isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: TextFormField(
                                autocorrect: widget.type != 'Email',
                                enabled: !widget.disabled,
                                cursorHeight:
                                    !kIsWeb && Platform.isAndroid ? 24 : null,
                                maxLength: widget.maxLength,
                                maxLines: null,
                                minLines: widget.minLines,
                                expands: widget.expands,
                                inputFormatters: widget.type == 'Email'
                                    ? [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'\s')),
                                      ]
                                    : widget.type == "phone"
                                        ? [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ]
                                        : [],
                                validator: widget.validator ??
                                    (value) {
                                      if (value!.isEmpty) {
                                        return "Required";
                                      }
                                      if (widget.type == "email" &&
                                          !_emailValidate(widget.controller!)) {
                                        return "Email format not matched";
                                      }
                                      if (widget.type == "password" &&
                                          value.length < 6) {
                                        return "Minimum of six alphanumeric characters";
                                      }
                                      if (widget.confirmPasscontroller !=
                                          null) {
                                        if (value !=
                                            widget
                                                .confirmPasscontroller!.text) {
                                          return "The passwords did not match.";
                                        } else {
                                          return null;
                                        }
                                      }

                                      return null;
                                    },
                                onTap: widget.onTap,
                                readOnly: widget.readOnly,
                                focusNode: widget.focusNode,
                                controller: widget.controller,
                                onChanged: widget.onChanged,
                                onEditingComplete: () {
                                  if (widget.nodeAfter != null) {
                                    return widget.nodeAfter!.requestFocus();
                                  }
                                  return FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                textInputAction: widget.textInputAction,
                                textAlign:
                                    widget.isArabic && widget.type != "email"
                                        ? TextAlign.right
                                        : TextAlign.left,
                                textAlignVertical: TextAlignVertical.center,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    height: 1.3),
                                keyboardType: widget.keyboardType ??
                                    (widget.type != null &&
                                            widget.type == "phone"
                                        ? TextInputType.phone
                                        : widget.type != null &&
                                                widget.type == "Email"
                                            ? TextInputType.emailAddress
                                            : TextInputType.text),
                                obscureText: widget.type != null &&
                                        widget.type == "password"
                                    ? !showPassword
                                    : false,
                                decoration: InputDecoration(
                                  hintText: widget.hintText,
                                  hintStyle: widget.hintTextstyle ??
                                      const TextStyle(
                                          fontSize: 20, color: primaryGrey),
                                  isDense: true,
                                  filled: widget.isFillColor,
                                  fillColor: widget.disabled
                                      ? const Color(0xffF2F2F2)
                                      : null,
                                  prefixIconConstraints: const BoxConstraints(
                                      maxHeight: 55,
                                      maxWidth: 70,
                                      minWidth: 40),
                                  suffix: const Padding(
                                    padding: EdgeInsets.only(left: 15),
                                  ),
                                  label: widget.useLabel
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: CustomText(
                                            text: widget.labelText.toString(),
                                            color: widget.textColor,
                                            fontSize: widget.fontSize ?? 13,
                                          ),
                                        )
                                      : null,
                                  labelStyle: widget.useLabel
                                      ? TextStyle(
                                          fontSize: widget.fontSize ?? 13,
                                          color: widget.textColor,
                                          height: 1.3)
                                      : null,
                                  prefixIcon: widget.type == "phone"
                                      ? Container(
                                          color: primaryColor,
                                          child: widget.phoneNumberPrefix)
                                      : widget.prefixIcon,
                                  prefix: widget.type == "phone"
                                      ? Padding(
                                          padding: widget.isArabic
                                              ? const EdgeInsets.only(right: 15)
                                              : const EdgeInsets.only(left: 15))
                                      : const Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              start: 10)),
                                  errorStyle: const TextStyle(
                                      fontSize: 10, height: 0.8),
                                  helperText: "",
                                  helperStyle: TextStyle(
                                      fontSize: widget.helperTextSize == true
                                          ? 10
                                          : 5),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                  )),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: widget.formBorderColor,
                                    width: 1,
                                  )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: widget.borderColor,
                                    width: 1,
                                  )),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: widget.formBorderColor,
                                    width: 1,
                                  )),
                                  contentPadding: widget.contentPadding ??
                                      EdgeInsetsDirectional.only(
                                        end: 0,
                                        top: 8,
                                        bottom: 18,
                                        start: widget.isContentPadding
                                            ? 0
                                            : widget.isArabic
                                                ? 10
                                                : 0,
                                      ),
                                  suffixIconConstraints: const BoxConstraints(
                                    maxHeight: 50,
                                  ),
                                  suffixIcon: widget.suffixIcon != null
                                      ? Padding(
                                          padding:
                                              widget.suffixIconPadding != null
                                                  ? widget.suffixIconPadding!
                                                  : const EdgeInsets.symmetric(
                                                      vertical: 9.5),
                                          child: widget.suffixIcon,
                                        )
                                      : widget.type != null &&
                                              widget.type == "password"
                                          ? GestureDetector(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(end: 8.0),
                                                child: Icon(
                                                  !showPassword
                                                      ? Icons.lock
                                                      : Icons.lock_open,
                                                  size: 18,
                                                  color: primaryColor,
                                                ),
                                              ),
                                              onTap: () => setState(() {
                                                showPassword = !showPassword;
                                              }),
                                            )
                                          : null,
                                )),
                          ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: widget.borderColor.withValues(alpha: 0.1),
                        border: Border.all(
                            color: widget.showError == true
                                ? Colors.red
                                : widget.borderColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                              child: CustomText(
                                  text: widget.fileExists == true
                                      ? 'File already exists'
                                      : widget.file != null
                                          ? widget.file!.path
                                              .split("/")
                                              .last
                                              .toString()
                                          : widget.hintText ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: widget.hintColor ??
                                      (widget.disabled
                                          ? Colors.black
                                          : widget.upload == true
                                              ? widget.fillColor != null
                                                  ? primaryColor
                                                  : Colors.black
                                              : Colors.white))),
                          if (widget.fileExists == true ||
                              (widget.upload == true && widget.file != null))
                            InkResponse(
                              onTap: widget.onTapDelete,
                              child: const Icon(
                                Icons.close,
                                color: primaryColor,
                              ),
                            )
                          else if (widget.upload == true && widget.file == null)
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/image/icon/upload-icon.svg'),
                                const SizedBox(width: 10),
                                CustomText(
                                  text: 'Tap to upload',
                                  fontSize: 14,
                                  color: primaryColor,
                                )
                              ],
                            )
                          else if (widget.upload == false)
                            widget.suffixIcon != null
                                ? widget.suffixIcon!
                                : Icon(Icons.keyboard_arrow_down_rounded,
                                    color: widget.disabled
                                        ? Colors.black
                                        : Colors.white)
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  bool _emailValidate(TextEditingController editingController) {
    const Pattern emailPattern =
        r"^((([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-zA-Z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-zA-Z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

    return (RegExp(emailPattern.toString(), caseSensitive: true)
        .hasMatch(editingController.text.trim()));
  }
}
