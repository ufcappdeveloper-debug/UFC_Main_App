import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_grey_divider.dart';
import 'package:ufc_mobile/screens/feed_old/profile/widgets/edit_profile_page/edit_profile_text_field.dart';

class EditProfileChangePasswordSection extends StatelessWidget {
  const EditProfileChangePasswordSection({
    super.key,
    required this.editPassword,
    required this.isEmailExist,
    required this.passwordFocusNode,
    required this.newPasswordFormKey,
    required this.newPasswordController,
    required this.onEditPasswordPressed,
    required this.oldPasswordController,
    required this.confirmPasswordController,
  });
  final bool editPassword;
  final bool isEmailExist;
  final Key newPasswordFormKey;
  final FocusNode passwordFocusNode;
  final VoidCallback onEditPasswordPressed;
  final TextEditingController newPasswordController;
  final TextEditingController oldPasswordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) => Column(children: [
        if (isEmailExist) const SizedBox(height: 31),
        if (isEmailExist)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CustomText(
                text: "Password".tr(),
                fontSize: 16,
                fontWeight: FontWeight.w500),
            !editPassword
                ? InkWell(
                    onTap: onEditPasswordPressed,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: SvgPicture.asset(
                        "assets/images/profile/edit_profile_icon.svg"))
                : InkWell(
                    onTap: onEditPasswordPressed,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: const Icon(Icons.close_rounded,
                        color: Colors.black, size: 20)),
          ]),
        if (isEmailExist) const CustomGreyDivider(),
        if (isEmailExist)
          Form(
              key: newPasswordFormKey,
              child: Column(children: [
                EditProfileTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else if (value.length < 6) {
                        return "At least 6 characters";
                      }
                      return null;
                    },
                    obscureText: true,
                    text: "Old password:",
                    readOnly: !editPassword,
                    hintText: "old password",
                    focusNode: passwordFocusNode,
                    controller: oldPasswordController,
                    keyboardType: TextInputType.emailAddress),
                EditProfileTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else if (value.length < 6) {
                        return "At least 6 characters";
                      }
                      return null;
                    },
                    obscureText: true,
                    text: "New password:",
                    readOnly: !editPassword,
                    hintText: "new password",
                    controller: newPasswordController,
                    keyboardType: TextInputType.emailAddress),
                EditProfileTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else if (value.length < 6) {
                        return "At least 6 characters";
                      } else if (value != newPasswordController.text) {
                        return "Must match new password";
                      }
                      return null;
                    },
                    obscureText: true,
                    readOnly: !editPassword,
                    text: "Confirm password:",
                    hintText: "confirm password",
                    textInputAction: TextInputAction.done,
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.emailAddress),
              ])),
        const SizedBox(height: 26),
      ]);
}
