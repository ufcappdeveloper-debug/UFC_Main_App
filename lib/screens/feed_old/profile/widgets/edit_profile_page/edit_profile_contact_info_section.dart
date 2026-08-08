import 'dart:ui' as ui;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_email_model.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_text_field.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_widgets.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_grey_divider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class EditProfileContactinfoSection extends StatefulWidget {
  const EditProfileContactinfoSection({
    super.key,
    required this.email,
    required this.editProfile,
    required this.isEmailExist,
    required this.isPhoneSelected,
    required this.passwordFormKey,
    required this.emailController,
    required this.passwordController,
    required this.rePasswordController,
    required this.onContactInfoChanged,
    required this.onCounrtyCodeChanged,
    required this.phoneNumberController,
  });
  final bool editProfile;
  final bool isEmailExist;
  final Key passwordFormKey;
  final bool isPhoneSelected;
  final UserEmailModel? email;
  final Function(bool) onContactInfoChanged;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController rePasswordController;
  final Function(CountryCode) onCounrtyCodeChanged;
  final TextEditingController phoneNumberController;

  @override
  State<EditProfileContactinfoSection> createState() =>
      _EditProfileContactinfoSectionState();
}

class _EditProfileContactinfoSectionState
    extends State<EditProfileContactinfoSection> {
  String mask = '000000000';
  CountryCode selectedCountryCode = CountryCode(code: 'SA', dialCode: '+966');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomText(
              text: "Contact Info".tr(),
              fontSize: 16,
              fontWeight: FontWeight.w500),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            contactInfoSwitch(
                icon: Icons.phone,
                isSelected: widget.isPhoneSelected,
                onPressed: () => widget.onContactInfoChanged(true)),
            kWidth10,
            contactInfoSwitch(
                icon: Icons.email,
                isSelected: !widget.isPhoneSelected,
                onPressed: () => widget.onContactInfoChanged(false)),
          ]),
        ]),
        const CustomGreyDivider(),
        if (widget.isPhoneSelected)
          Row(
            children: [
              Expanded(
                flex: 1,
                child: CustomText(
                  text: "Phone #:".tr(),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF898989),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Directionality(
                    //            textDirection: (isArOrUr)
                    // ? ui.TextDirection.rtl
                    // : ui.TextDirection.ltr,
                    textDirection: ui.TextDirection.ltr,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: (isArOrUr)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CountryCodePicker(
                                enabled: false,
                                initialSelection: "SA",
                                favorite: const ['+966'],
                                builder: (countryCode) => InkWell(
                                    onTap: AppConfig.server == Build.dev
                                        ? null
                                        : () {},
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                              width: 25,
                                              countryCode!.flagUri!,
                                              package: 'country_code_picker'),
                                          const SizedBox(width: 5),
                                          Text(countryCode.toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Kanit',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400)),
                                          const SizedBox(width: 8),
                                        ])),
                                onChanged: (value) {
                                  selectedCountryCode = value;
                                  widget.onCounrtyCodeChanged(value);
                                },
                              ),
                              Expanded(
                                child: TextFormField(
                                  cursorColor: primaryColor,
                                  readOnly: !widget.editProfile,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  controller: widget.phoneNumberController,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Kanit',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                  inputFormatters: [
                                    PhoneInputFormatter(
                                        defaultCountryCode:
                                            selectedCountryCode.code,
                                        onCountrySelected: (c) => mask = c
                                                ?.getCorrectMask(
                                                    selectedCountryCode
                                                        .dialCode)
                                                .replaceAll(" ", "") ??
                                            '000000000'),
                                  ],
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (mask.length !=
                                          value.replaceAll(" ", "").length) {
                                        return "Invalid number";
                                      }
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () => FocusManager
                                      .instance.primaryFocus
                                      ?.nextFocus(),
                                  decoration: profilePhoneDecoration(
                                      !widget.editProfile, "56 123 4567"),
                                  //  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (!widget.isPhoneSelected)
          Form(
            key: widget.passwordFormKey,
            child: Column(
              children: [
                EditProfileTextField(
                    validator: (value) {
                      if ((widget.passwordController.text.isNotEmpty ||
                              widget.rePasswordController.text.isNotEmpty) &&
                          (value == null || value.isEmpty)) {
                        return 'Required';
                      } else if (value != null &&
                          value.isNotEmpty &&
                          !EmailValidator.validate(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    text: "Email:",
                    readOnly: !widget.editProfile,
                    hintText: "username@gmail.com",
                    controller: widget.emailController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress),
                if (!widget.isEmailExist)
                  EditProfileTextField(
                      validator: (value) {
                        if ((widget.emailController.text.isNotEmpty ||
                                widget.rePasswordController.text.isNotEmpty) &&
                            (value == null || value.isEmpty)) {
                          return 'Required';
                        } else if ((widget.emailController.text.isNotEmpty ||
                                widget.rePasswordController.text.isNotEmpty) &&
                            value!.length < 6) {
                          return "At least 6 characters";
                        }
                        return null;
                      },
                      text: "Password:",
                      hintText: "password",
                      readOnly: !widget.editProfile,
                      controller: widget.passwordController,
                      textInputAction: TextInputAction.done),
                if (!widget.isEmailExist)
                  EditProfileTextField(
                      validator: (value) {
                        if ((widget.emailController.text.isNotEmpty ||
                                widget.passwordController.text.isNotEmpty) &&
                            (value == null || value.isEmpty)) {
                          return 'Required';
                        } else if ((widget.emailController.text.isNotEmpty ||
                                widget.passwordController.text.isNotEmpty) &&
                            value!.length < 6) {
                          return "At least 6 characters";
                        } else if ((widget.emailController.text.isNotEmpty ||
                                widget.passwordController.text.isNotEmpty) &&
                            value != widget.passwordController.text) {
                          return "Must match password";
                        }
                        return null;
                      },
                      text: "Re - Password:",
                      readOnly: !widget.editProfile,
                      hintText: "re - password",
                      controller: widget.rePasswordController,
                      textInputAction: TextInputAction.done),
              ],
            ),
          ),
      ],
    );
  }

  Widget contactInfoSwitch({
    required IconData icon,
    VoidCallback? onPressed,
    required bool isSelected,
  }) {
    final borderRaduis = BorderRadius.circular(33);
    final splashColor =
        isSelected ? Colors.white.withValues(alpha: 0.23) : null;
    final selectedDecoration = BoxDecoration(
        color: primaryColor,
        borderRadius: borderRaduis,
        border: Border.all(width: 1, color: Colors.white));
    final unSelectedDecoration = BoxDecoration(
        borderRadius: borderRaduis,
        color: const Color(0xFF898989).withValues(alpha: 0.07),
        border: Border.all(width: 1, color: const Color(0xFF898989)));

    return SizedBox(
        width: 50,
        height: 23,
        child: DecoratedBox(
            decoration: isSelected ? selectedDecoration : unSelectedDecoration,
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: onPressed,
                    splashColor: splashColor,
                    borderRadius: borderRaduis,
                    highlightColor: splashColor,
                    child: Icon(icon,
                        size: 20,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF898989))))));
  }
}
