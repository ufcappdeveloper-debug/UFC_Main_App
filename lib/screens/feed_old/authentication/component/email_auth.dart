import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/feed_auth_utils.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/widgets/email_auth_widgets.dart';

import '../../../../global/shared/widgets/custom_button.dart';
import '../../../../global/shared/widgets/custom_text_field.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../global/shared/widgets/loading/loading_dialog.dart';
import '../../../../riverpod/auth/auth.dart';

class EmailAuth extends ConsumerStatefulWidget {
  final bool? fromAccount;
  const EmailAuth({super.key, this.fromAccount});

  @override
  ConsumerState<EmailAuth> createState() => _EmailAuthState();
}

class _EmailAuthState extends ConsumerState<EmailAuth>
    with AutomaticKeepAliveClientMixin {
  bool passVisibility = true;
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      emailController.text = AppConfig.server == Build.production
          ? "info@faisalkc.com"
          : "john5@user.test";
      passwordController.text = "12345678Test!";
    }

    if (widget.fromAccount == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        forgetPassOntap();
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  void forgetPassOntap() async {
    final list = await resetUserPasswordEmail(context);
    if (list != null && list.first.isNotEmpty) {
      Map<String, String> data = {"email": list.first};
      final resetFuture =
          ref.read(authProvider.notifier).resetUserPasswordEmail(data);
      if (!mounted) return;
      await LoadingDialog.show(context, resetFuture);

      // Forget Passowrd: Enter OTP Dialog
      if (!mounted) return;
      final otp = await showVerificationOTPDialog(context, list.first);
      if (otp == null || otp.isEmpty) return;
      final otpData = {"otp": otp};
      data.addEntries(otpData.entries);

      // Forget Passowrd: Enter New Password Dialog
      if (!mounted) return;
      final newPassword = await enterEmailNewPasswordDialog(context);
      if (newPassword == null || newPassword.isEmpty) return;
      final passwordData = {"password": newPassword};
      data.addEntries(passwordData.entries);

      // Forget Passowrd: Verify Reset User Password Email
      final verifyFuture =
          ref.read(authProvider.notifier).verifyResetUserPasswordEmail(data);
      if (!mounted) return;
      await LoadingDialog.show(context, verifyFuture);
      if (mounted) {
        CustomSnackBar.success(context, "Password reset successfully");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Form(
        key: _key,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
                focusNode: emailNode,
                labelText: 'Email'.tr(),
                nodeAfter: passwordNode,
                controller: emailController,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                errorStyle: const TextStyle(
                    fontFamily: "Kanit", fontSize: 14, color: Colors.yellow),
                validation: (value) {
                  if (value!.isEmpty) {
                    return "Required".tr();
                  } else if (!EmailValidator.validate(value)) {
                    return "Enter a valid email".tr();
                  }
                  return null;
                }),
            const Flexible(
              child: SizedBox(
                height: 40,
              ),
            ),
            CustomTextField(
                obscureText: !passVisibility,
                suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passVisibility = !passVisibility;
                      });
                    },
                    child: Icon(
                      passVisibility ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    )),
                focusNode: passwordNode,
                labelText: 'Password'.tr(),
                textInputType: TextInputType.text,
                controller: passwordController,
                textInputAction: TextInputAction.done,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                errorStyle: const TextStyle(
                    fontFamily: "Kanit", fontSize: 14, color: Colors.yellow),
                validation: (value) {
                  if (value!.isEmpty) {
                    return "Required".tr();
                  } else if (value.length < 6) {
                    return "At least 6 characters".tr();
                  }
                  return null;
                }),
            Flexible(
                child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    try {
                      // Forget Passowrd: Reset User Password Email
                      forgetPassOntap();
                    } catch (e) {
                      debugLog(e.toString());
                      if (!mounted) return;
                      CustomSnackBar.error(context, e.toString());
                    }
                  },
                  child: Text(
                    "Forget Password".tr(),
                    style: const TextStyle(
                        color: Colors.white,
                        decorationColor: Colors.white,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            )),
            const Flexible(
              child: SizedBox(
                height: 30,
              ),
            ),
            Flexible(
              child: CustomButton(
                title: 'Sign in'.tr(),
                onTap: () async {
                  if (_key.currentState!.validate()) {
                    try {
                      final data = {
                        "email": emailController.text,
                        "password": passwordController.text,
                      };
                      final future =
                          ref.read(authProvider.notifier).loginWithEmail(data);
                      await LoadingDialog.show(context, future);

                      if (!context.mounted) return;
                      AuthUtils.showNearbyStations(context, ref: ref);
                    } catch (e) {
                      if (!context.mounted) return;
                      if (e.toString().contains('Email not verified')) {
                        await showVerifyEmailDialog(
                            context, emailController.text);
                      } else {
                        CustomSnackBar.error(context, e.toString());
                      }
                    }
                  }
                },
                height: 42,
                width: 287,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
