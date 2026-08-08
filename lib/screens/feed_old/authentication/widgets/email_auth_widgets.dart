import 'dart:ui' as ui;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';

// Reset User Password Email
Future<List<String>?> resetUserPasswordEmail(
        final BuildContext context) async =>
    await showTextInputDialog(
      context: context,
      title: "Forget Password".tr(),
      message:
          "Enter the registered email to receive the forget password link".tr(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          cupertinoOverrideTheme:
              const CupertinoThemeData(primaryColor: mediumGreenColor),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: mediumGreenColor),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: mediumGreenColor,
              ),
            ),
          ),
        ),
        child: child,
      ),
      textFields: [
        DialogTextField(
          hintText: "enter email".tr(),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return "Required".tr();
            } else if (!EmailValidator.validate(value)) {
              return "Enter a valid email".tr();
            }
            return null;
          },
        ),
      ],
    );

// Email Verification OTP Dialog
Future<String?> showVerificationOTPDialog(
    final BuildContext context, final String email) async {
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
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  TextEditingController otpCodeController = TextEditingController();
  return await showDialog<String?>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Form(
          key: otpFormKey,
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
                        text: "Please type the OTP sent to your email ".tr()),
                    TextSpan(
                      text: email,
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
                    Center(
                    child: Directionality(
                      textDirection: ui.TextDirection.ltr,
                child: Pinput(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required".tr();
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
                  controller: otpCodeController,
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
                    )
              ),
              kHeight20,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (otpFormKey.currentState!.validate()) {
                        Navigator.pop(context, otpCodeController.text);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: CustomText(
                      text: "Submit".tr(),
                      fontSize: 14,
                      color: Colors.white,
                    ),
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
  //return otpCodeController.text;
}

// Email New Pasword Dialog
Future<String?> enterEmailNewPasswordDialog(final BuildContext context,
    {Function(String newPass)? onSubmit}) async {
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  Widget submit() => TextButton(
        onPressed: onSubmit != null
            ? () {
                if (otpFormKey.currentState!.validate()) {
                  onSubmit(newPasswordController.text);
                  Navigator.pop(context);
                }
              }
            : () {
                if (otpFormKey.currentState!.validate()) {
                  Navigator.pop(context);
                }
              },
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

  await showDialog<Future<void>>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: otpFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: "Reset Password".tr(),
                      fontSize: 30,
                      fontWeight: FontWeight.w400),
                  kHeight5,
                  CustomText(
                      text:
                          "Choose a new & strong password of minimum 6 characters."
                              .tr(),
                      fontSize: 15,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff939393)),
                  kHeight20,
                  TextFormField(
                    autofocus: true,
                    cursorColor: primaryColor,
                    controller: newPasswordController,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.visiblePassword,
                    onEditingComplete: () =>
                        FocusManager.instance.primaryFocus?.nextFocus(),
                    decoration: InputDecoration(
                        hintText: 'new password'.tr(),
                        hintStyle: const TextStyle(
                            fontSize: 16, color: Color(0xFF646264)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required".tr();
                      } else if (value.length < 6) {
                        return "At least 6 characters".tr();
                      }
                      return null;
                    },
                  ),
                  kHeight20,
                  TextFormField(
                    cursorColor: primaryColor,
                    controller: confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    onEditingComplete: () =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(
                        hintText: 'confirm password'.tr(),
                        hintStyle: const TextStyle(
                            fontSize: 16, color: Color(0xFF646264)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required".tr();
                      } else if (value.length < 6) {
                        return "At least 6 characters".tr();
                      } else if (value != newPasswordController.text) {
                        return "Must match new password".tr();
                      }
                      return null;
                    },
                  ),
                  kHeight20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      onSubmit != null
                          ? BlocConsumer<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is ResetPasswordSuccess) {
                                  CustomSnackBar.success(
                                      context, 'Password reset successfully');
                                } else if (state is ProfileEditFailure) {
                                  CustomSnackBar.error(
                                      context, state.message.toString());
                                }
                              },
                              builder: (context, state) {
                                return submit();
                              },
                            )
                          : submit(),
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
          ),
        ),
      );
    },
  );
  return newPasswordController.text;
}

// Email Verification Dialog
Future showVerifyEmailDialog(
        final BuildContext context, final String email) async =>
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Email Verification".tr(),
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
              kHeight5,
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                    color: Color(0xff939393),
                  ),
                  children: [
                    TextSpan(
                        text: "To verify your new email, please check your "
                            .tr()),
                    TextSpan(
                      text: email,
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
              kHeight5,
              CustomText(
                text:
                    "(Please note: You must verify your email address before logging in again.)"
                        .tr(),
                fontSize: 11,
                color: const Color(0xff939393),
                // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit'
                fontFamily:
                    isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
              ),
              kHeight20,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: CustomText(
                      text: "Ok".tr(),
                      fontSize: 14,
                      color: Colors.white,
                    ),
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
        );
      },
    );
