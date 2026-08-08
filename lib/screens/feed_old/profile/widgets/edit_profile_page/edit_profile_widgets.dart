import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';

// Phone Verification Dialog
Future<String?> showSMSCodeDialog(
  final BuildContext context,
  final String value, {
  bool isEmail = false,
  Function(String v, BuildContext cxt)? onSubmit,
}) async {
  const pinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    decoration: BoxDecoration(
      border: Border(
          bottom: BorderSide(
        width: 1,
        color: Color(0xFF6C6A6A),
      )),
    ),
  );
  GlobalKey<FormState> smsFormKey = GlobalKey<FormState>();
  TextEditingController smsCodeController = TextEditingController();

  Widget submitButton(Function() onSubmit) => TextButton(
        onPressed: onSubmit,
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        child: CustomText(
          text: "Submit".tr(),
          fontSize: 14,
          color: Colors.white,
        ),
      );

  await showDialog<String?>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Form(
          key: smsFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "OTP Verification".tr(),
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
              kHeight5,
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Kanit',
                    color: Color(0xff939393),
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                        text: (isEmail
                                ? "Please type the OTP sent to your email "
                                : "Please type the OTP sent to your mobile number ")
                            .tr()),
                    TextSpan(
                      text: isEmail
                          ? value
                          : isArOrUr ? "${value.substring((value.length) - 2)}xxxxxxxx" :
                          "xxxxxxxx${value.substring((value.length) - 2)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              kHeight10,
              Directionality(
                 textDirection: ui.TextDirection.ltr,
                child: Pinput(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                  errorTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFd32f2f),
                  ),
                  length: 6,
                  autofocus: true,
                  forceErrorState: true,
                  defaultPinTheme: pinTheme,
                  controller: smsCodeController,
                  focusedPinTheme: pinTheme.copyWith(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        width: 1,
                        color: primaryColor,
                      )),
                    ),
                  ),
                ),
              ),
              kHeight20,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  onSubmit != null
                      ?  submitButton(
                              () {
                                if (smsFormKey.currentState!.validate()) {
                                  onSubmit(smsCodeController.text, context);
                                }
                              },
                        )
                      : submitButton(
                          () {
                            if (smsFormKey.currentState!.validate()) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                  kWidth10,
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: Colors.white,
                    ),
                    child: CustomText(
                      text: "Cancel".tr(),
                      fontSize: 14,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return smsCodeController.text;
}

// Change User Data Confirmation Dialog
Future showChangeUserDataConfirmationDialog(
  final BuildContext context, {
  bool isEmailChanged = false,
  bool isPhoneChanged = false,
}) async {
  String? warningMessage;
  if (isEmailChanged && isPhoneChanged) {
    warningMessage =
        ' Your email and phone number changed. \nTo ensure account security, please take a moment to verify these changes.';
  } else if (isEmailChanged) {
    warningMessage =
        ' Your email changed. \nTo ensure account security, please take a moment to verify these changes.';
  } else if (isPhoneChanged) {
    warningMessage =
        ' Your phone number changed. \nTo ensure account security, please take a moment to verify these changes.';
  } else {
    return;
  }
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => Dialog(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Attention!".tr(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontFamily: 'Lexend Deca',
                            fontWeight: FontWeight.bold)),
                    kHeight5,
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: const TextStyle(
                                height: 1.7,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(text: warningMessage?.tr()),
                            ])),
                    const SizedBox(height: 15),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                            backgroundColor: Colors.white,
                          ),
                          child: CustomText(
                              text: "Cancel".tr(),
                              fontSize: 14,
                              color: primaryColor)),
                      kWidth10,
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white),
                          child: CustomText(
                              text: "Verify".tr(),
                              fontSize: 14,
                              color: Colors.white)),
                    ]),
                  ]))));
}

InputDecoration profilePhoneDecoration(bool readOnly, String hintText,
    {Widget? prefix}) {
  return InputDecoration(
    isDense: true,
    prefix: prefix,
    hintText: hintText,
    hintStyle: const TextStyle(
      fontSize: 14,
      fontFamily: 'Kanit',
      color: Color(0xFF898989),
      fontWeight: FontWeight.w300,
    ),
    border: readOnly
        ? InputBorder.none
        : const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFFE1E1E1)),
          ),
    enabledBorder: readOnly
        ? InputBorder.none
        : const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFFE1E1E1)),
          ),
    focusedBorder: readOnly
        ? InputBorder.none
        : const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: primaryColor),
          ),
  );
}
