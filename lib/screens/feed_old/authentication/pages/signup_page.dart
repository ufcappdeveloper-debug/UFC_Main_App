import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_text_field.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/state/visibility.dart';
import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/feed_auth_utils.dart';

import '../../../../global/shared/social_login/apple_sign_in.dart';
import '../../../../global/shared/social_login/google_signin.dart';
import '../../../../global/shared/social_login/twitter_signin.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../riverpod/auth/auth.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final emailNode = FocusNode();
  final phoneNode = FocusNode();
  final confirmNode = FocusNode();
  final passwordNode = FocusNode();
  final emailController = TextEditingController();
  final confirmController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future(() {
      ref.read(passwordVisibility.notifier).state = false;
      ref.read(rePasswordVisibility.notifier).state = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailNode.dispose();
    phoneNode.dispose();
    confirmNode.dispose();
    passwordNode.dispose();
    emailController.dispose();
    confirmController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool passVisibility = ref.watch(passwordVisibility);
    bool rePassVisibility = ref.watch(rePasswordVisibility);
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent, //Colors.green[900],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
        ),
        body: Stack(children: [
          Image.asset('assets/images/authentication/background.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover),
          SingleChildScrollView(
              child: SafeArea(
                  child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                'assets/images/authentication/logo.svg'),
                            const SizedBox(height: 40),
                            Form(
                                key: _key,
                                child: Column(
                                  children: [
                                    CustomTextField(
                                        focusNode: emailNode,
                                        labelText: 'Email'.tr(),
                                        nodeAfter: passwordNode,
                                        controller: emailController,
                                        textInputType: TextInputType.text,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        textInputAction: TextInputAction.next,
                                        errorStyle: const TextStyle(
                                            fontFamily: "Kanit",
                                            fontSize: 14,
                                            color: Colors.yellow),
                                        validation: (value) {
                                          if (value!.isEmpty) {
                                            return "Required".tr();
                                          } else if (!EmailValidator.validate(
                                              value)) {
                                            return "Enter a valid email".tr();
                                          }
                                          return null;
                                        }),
                                    CustomTextField(
                                        // obscureText: !passVisibility,
                                        suffixIcon: InkWell(
                                            onTap: () => ref
                                                    .read(passwordVisibility
                                                        .notifier)
                                                    .state =
                                                !ref
                                                    .read(passwordVisibility
                                                        .notifier)
                                                    .state,
                                            child: Icon(
                                              passVisibility
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white,
                                            )),
                                        focusNode: passwordNode,
                                        labelText: 'Password'.tr(),
                                        textInputType: TextInputType.text,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        controller: passwordController,
                                        textInputAction: TextInputAction.next,
                                        nodeAfter: confirmNode,
                                        errorStyle: const TextStyle(
                                            fontFamily: "Kanit",
                                            fontSize: 14,
                                            color: Colors.yellow),
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Required".tr();
                                          } else if (value.length < 6) {
                                            return "At least 6 characters".tr();
                                          } else if (value.length > 20) {
                                            return "Must not exceed 20 characters"
                                                .tr();
                                          }
                                          return null;
                                        }),
                                    CustomTextField(
                                      obscureText: !rePassVisibility,
                                      suffixIcon: InkWell(
                                          onTap: () => ref
                                                  .read(rePasswordVisibility
                                                      .notifier)
                                                  .state =
                                              !ref
                                                  .read(rePasswordVisibility
                                                      .notifier)
                                                  .state,
                                          child: Icon(
                                            rePassVisibility
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.white,
                                          )),
                                      focusNode: confirmNode,
                                      textInputType: TextInputType.text,
                                      labelText: 'Re-type Password'.tr(),
                                      controller: confirmController,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      textInputAction: TextInputAction.done,
                                      errorStyle: const TextStyle(
                                          fontFamily: "Kanit",
                                          fontSize: 14,
                                          color: Colors.yellow),
                                      validation: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Required".tr();
                                        } else if (value.length < 6) {
                                          return "At least 6 characters".tr();
                                        } else if (value.length > 20) {
                                          return "Must not exceed 20 characters"
                                              .tr();
                                        } else if (value !=
                                            passwordController.text) {
                                          return "Must match password".tr();
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    CustomButton(
                                      width: 287,
                                      height: 42,
                                      title: 'Sign up'.tr(),
                                      onTap: () async {
                                        if (_key.currentState!.validate()) {
                                          if (passwordController.text !=
                                              confirmController.text) {
                                            CustomSnackBar.error(context,
                                                'Password and Re-type password did not match');
                                            return;
                                          }
                                          try {
                                            final data = {
                                              "email": emailController.text,
                                              "password":
                                                  passwordController.text,
                                            };
                                            final future = ref
                                                .read(authProvider.notifier)
                                                .registerWithEmail(data);
                                            await LoadingDialog.show(
                                                context, future);

                                            if (!context.mounted) return;
                                            AdjustTracker.trackSignUp();
                                            CustomSnackBar.success(context,
                                                'Account Created successfully');
                                            Navigator.pop(context);
                                          } catch (e) {
                                            if (!mounted) return;
                                            CustomSnackBar.error(
                                                context, e.toString());
                                          }
                                        }
                                      },
                                    )
                                  ],
                                )),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                        thickness: 2,
                                        height: 20,
                                        color: Colors.white
                                            .withValues(alpha: 0.5)),
                                  ),
                                  CustomText(
                                      text: ' Or sign up with '.tr(),
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                      fontFamily: 'Kanit'),
                                  Expanded(
                                    child: Divider(
                                        thickness: 2,
                                        height: 20,
                                        color: Colors.white
                                            .withValues(alpha: 0.5)),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                socialLoginButton(
                                  onTap: () async {
                                    try {
                                      final data =
                                          await signInWithGoogle(context);

                                      final future = ref
                                          .read(authProvider.notifier)
                                          .googleSociaLogin(data);
                                      if (!context.mounted) return;
                                      await LoadingDialog.show(context, future);

                                      if (!context.mounted) return;
                                      AuthUtils.showNearbyStations(context,
                                          ref: ref);
                                    } catch (e) {
                                      if (!mounted) return;
                                      CustomSnackBar.error(
                                          context, e.toString());
                                    }
                                  },
                                  iconPath:
                                      'assets/images/authentication/google-icon.svg',
                                ),
                                if (Platform.isIOS)
                                  socialLoginButton(
                                    onTap: () async {
                                      try {
                                        final data =
                                            await signInWithApple(context);

                                        final future = ref
                                            .read(authProvider.notifier)
                                            .appleSociaLogin(data);
                                        if (!context.mounted) return;
                                        await LoadingDialog.show(
                                            context, future);

                                        if (!context.mounted) return;
                                        AuthUtils.showNearbyStations(context,
                                            ref: ref);
                                      } catch (e) {
                                        if (!mounted) return;
                                        CustomSnackBar.error(
                                            context, e.toString());
                                      }
                                    },
                                    iconPath:
                                        'assets/images/authentication/Apple logo.svg',
                                  ),
                                socialLoginButton(
                                  onTap: () async {
                                    try {
                                      final user =
                                          await signInWithTwitter(context);

                                      final data = {
                                        "twitter_id": user.id,
                                        "twitter_email": user.email,
                                        "name": user.name,
                                      };
                                      final future = ref
                                          .read(authProvider.notifier)
                                          .twitterSociaLogin(data);
                                      if (!context.mounted) return;
                                      await LoadingDialog.show(context, future);

                                      if (!context.mounted) return;
                                      AuthUtils.showNearbyStations(context,
                                          ref: ref);
                                    } catch (e) {
                                      if (!mounted) return;
                                      CustomSnackBar.error(
                                          context, e.toString());
                                    }
                                  },
                                  icon: Image.asset(
                                      'assets/images/authentication/X logo.png',
                                      height: 24),
                                ),
                              ],
                            ),
                            TextButton(
                                onPressed: () => Navigator.pop(
                                      context,
                                    ),
                                child: CustomText(
                                    text:
                                        'Already have an account? Sign in'.tr(),
                                    decorationColor:
                                        Colors.white.withValues(alpha: 0.8),
                                    decoration: TextDecoration.underline,
                                    color:
                                        Colors.white.withValues(alpha: 0.8))),
                          ])))),
        ]));
  }

  InkWell socialLoginButton(
      {required Function() onTap, String? iconPath, Widget? icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 48,
          width: 75,
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 27),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    color: Colors.black.withValues(alpha: 0.2))
              ]),
          child: icon ?? SvgPicture.asset(iconPath!)),
    );
  }
}
