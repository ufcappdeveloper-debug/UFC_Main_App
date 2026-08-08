import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/social_login/apple_sign_in.dart';
import 'package:ufc_mobile/global/shared/social_login/google_signin.dart';
import 'package:ufc_mobile/global/shared/social_login/twitter_signin.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_text_field.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';

import '../../../../../global/extensions/app_images.dart';
import '../../../../../global/util/common/common_utils.dart';

class FeedSignUpPage extends StatefulWidget {
  final AppType appType;
  const FeedSignUpPage({super.key, required this.appType});

  @override
  State<FeedSignUpPage> createState() => _FeedSignUpPageState();
}

class _FeedSignUpPageState extends State<FeedSignUpPage> {
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  final confirmNode = FocusNode();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final color = CommonUtils.getAppThemeColor(widget.appType);
    final logo = CommonUtils.getAppLogo(widget.appType);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: flutter.TextDirection.ltr,
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    size: 18, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: CustomText(
              textAlign: TextAlign.center,
              text: 'All rights reserved. United Feed – 2025',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                // Optionally show a loading indicator
                // You could show a loading dialog here
              } else if (state is RegisterSuccess) {
                emailController.clear();
                passwordController.clear();
                confirmController.clear();
                CustomSnackBar.success(context, state.message);
                Navigator.pop(context, true);
              } else if (state is AuthError) {
                ErrorHandler.handleError(context, state.message);
              }
            },
            child: Form(
                key: _formKey,
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0, 0.65],
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [color, Colors.white],
                      ),
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: AssetImage(AppImages.loginBackground),
                      ),
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SingleChildScrollView(
                          reverse: true,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight),
                              child: IntrinsicHeight(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                    Image.asset(
                                      logo,
                                      width: 52.77,
                                      height: 101.25,
                                      fit: BoxFit.contain,
                                    ),
                                    kHeight35,
                                    CustomText(
                                      text: 'Welcome to United Feeds!',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26,
                                      color: color,
                                      textAlign: TextAlign.center,
                                      height: isEnglish ? null : 1.6,
                                    ),
                                    kHeight5,
                                    CustomText(
                                      overflow: TextOverflow.visible,
                                      text:
                                          'Feed, Veterinary services, Farm, Community.',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              kHeight30,
                                              CustomText(
                                                text:
                                                    'Create a new account'.tr(),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                              kHeight20,
                                              CustomTextFormField(
                                                focusNode: emailNode,
                                                nodeAfter: passwordNode,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                fromLogin: true,
                                                context: context,
                                                hintText: 'Email'.tr(),
                                                controller: emailController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return 'Please enter your email'
                                                        .tr();
                                                  } else if (value.isNotEmpty) {
                                                    final emailRegex = RegExp(
                                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                                    if (!emailRegex
                                                        .hasMatch(value)) {
                                                      return 'Enter a valid email'
                                                          .tr();
                                                    }
                                                  }
                                                  return null;
                                                },
                                              ),
                                              kHeight20,
                                              CustomTextFormField(
                                                obscureText: true,
                                                focusNode: passwordNode,
                                                nodeAfter: confirmNode,
                                                keyboardType:
                                                    TextInputType.text,
                                                fromLogin: true,
                                                context: context,
                                                hintText: 'Password'.tr(),
                                                controller: passwordController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Required".tr();
                                                  } else if (value.length < 6) {
                                                    return "At least 6 characters"
                                                        .tr();
                                                  } else if (value.length >
                                                      20) {
                                                    return "Must not exceed 20 characters"
                                                        .tr();
                                                  }
                                                  return null;
                                                },
                                              ),
                                              kHeight20,
                                              CustomTextFormField(
                                                obscureText: true,
                                                focusNode: confirmNode,
                                                keyboardType:
                                                    TextInputType.text,
                                                context: context,
                                                hintText:
                                                    'Re-type Password'.tr(),
                                                controller: confirmController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Required".tr();
                                                  } else if (value.length < 6) {
                                                    return "At least 6 characters"
                                                        .tr();
                                                  } else if (value.length >
                                                      20) {
                                                    return "Must not exceed 20 characters"
                                                        .tr();
                                                  } else if (value !=
                                                      passwordController.text) {
                                                    return "Must match password"
                                                        .tr();
                                                  }
                                                  return null;
                                                },
                                              ),
                                              kHeight20,
                                              BlocBuilder<AuthCubit, AuthState>(
                                                  builder: (context, state) {
                                                bool isLoading =
                                                    state is AuthLoading;
                                                return CustomButton(
                                                    color: color,
                                                    isLoading: isLoading,
                                                    radius: 15,
                                                    width: double.infinity,
                                                    height: 55,
                                                    title:
                                                        'Send verification code'
                                                            .tr(),
                                                    onTap: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        if (passwordController
                                                                .text !=
                                                            confirmController
                                                                .text) {
                                                          CustomSnackBar.error(
                                                              context,
                                                              'Password and Re-type password did not match');
                                                          return;
                                                        }

                                                        try {
                                                          final data = {
                                                            "email":
                                                                emailController
                                                                    .text,
                                                            "password":
                                                                passwordController
                                                                    .text,
                                                          };

                                                          context
                                                              .read<AuthCubit>()
                                                              .registerWithEmail(
                                                                  data);
                                                        } catch (e) {
                                                          if (!mounted) return;
                                                          CustomSnackBar.error(
                                                              context,
                                                              e.toString());
                                                        }
                                                      }
                                                    });
                                              }),
                                            ]))
                                  ]))));
                    })))));
  }
}

class SocialLoginSection extends StatelessWidget {
  final AppType appType;
  final VoidCallback? onReturnedFromSignUp;
  const SocialLoginSection({
    super.key,
    required this.appType,
    this.onReturnedFromSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          if (appType == AppType.farm || appType == AppType.community)
            kHeight10,
          Row(
            children: [
              Expanded(
                  child: Divider(thickness: 1, height: 20, color: Colors.grey)),
              CustomText(
                text: ' Or sign in with '.tr(),
                color: Color(0xff44444F),
                fontFamily: 'Kanit',
              ),
              Expanded(
                  child: Divider(thickness: 1, height: 20, color: Colors.grey)),
            ],
          ),
          kHeight10,
          socialLoginButton(
            onTap: () async {
              final data = await signInWithGoogle(context);
              if (!context.mounted) return;
              await context.read<AuthCubit>().googleSociaLogin(data);
            },
            iconPath: 'assets/images/authentication/google-icon.svg',
            title: 'Sign in with Google'.tr(),
          ),
          if (Platform.isIOS)
            socialLoginButton(
              onTap: () async {
                final data = await signInWithApple(context);
                if (!context.mounted) return;
                await context.read<AuthCubit>().appleSociaLogin(data);
              },
              iconPath: 'assets/images/authentication/Apple logo.svg',
              title: 'Sign in with Apple',
            ),
          socialLoginButton(
            onTap: () async {
              final user = await signInWithTwitter(context);
              final data = {
                "twitter_id": user.id,
                "twitter_email": user.email,
                "name": user.name,
              };
              if (!context.mounted) return;
              await context.read<AuthCubit>().twitterSociaLogin(data);
            },
            icon: Image.asset(
              'assets/images/authentication/X logo.png',
              height: 24,
            ),
            title: 'Sign in with X'.tr(),
          ),
          TextButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedSignUpPage(appType: appType),
                ),
              );

              if (result == true && onReturnedFromSignUp != null) {
                onReturnedFromSignUp!();
              }
            },
            child: CustomText(
              fontSize: 13,
              // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
              fontFamily:
                  isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
              text: 'Create a new account'.tr(),
              decoration: TextDecoration.underline,
              color: Colors.black,
            ),
          ),
          kHeight20,
        ],
      ),
    );
  }
}

InkWell socialLoginButton({
  required Function() onTap,
  String? iconPath,
  Widget? icon,
  required String title,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 42,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? SvgPicture.asset(iconPath!),
          const SizedBox(width: 15),
          CustomText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    ),
  );
}
