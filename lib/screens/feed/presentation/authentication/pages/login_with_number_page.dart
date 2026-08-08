import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/translations/l10n.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/exception/error_handler.dart';
import 'package:ufc_mobile/riverpod/app_bar/app_bar_riverpod.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/pages/opt_screen.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/pages/sign_up_page.dart';
import 'package:ufc_mobile/screens/feed/presentation/authentication/widgets/feed_guest_continue_button.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/feed_auth_utils.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/widgets/email_auth_widgets.dart';
import 'package:ufc_mobile/screens/landing_page.dart';

import '../../../../../global/extensions/app_images.dart';
import '../../../../../global/shared/widgets/custom_button.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../../global/util/common/common_utils.dart';
import '../../../../../global/util/storage/local_storage.dart';
import '../../../../../main.dart';
import '../../../../farm/presentation/widgets/farm_text_field.dart';
import '../../../../pet_veterinary/service/chat_socket_manager.dart';

class LoginWithNumber extends ConsumerStatefulWidget {
  final AppType appType;
  final bool isNotFromStart;
  const LoginWithNumber({
    super.key,
    required this.appType,
    this.isNotFromStart = false,
  });

  @override
  ConsumerState<LoginWithNumber> createState() => _LoginWithNumberState();
}

class _LoginWithNumberState extends ConsumerState<LoginWithNumber> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  String selectedCountry = '+966';

  bool isTryingPhoneLogin = false;
  bool isTryingEmailLogin = false;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _initChat();
    Future.microtask(_initLanguage);
  }

  Future<void> _initChat() async => ChatSocketManager.init();

  Future<void> _initLanguage() async {
    final int? langIndex = preferences.getInt(LocalStorage.language);
    Future(() {
      if (mounted) {
        context.setLocale(L10n.all[langIndex ?? 0]);
        context.read<LanguageCubit>().switchLanguage(
              context: context,
              localeString: L10n.all[langIndex ?? 0].languageCode,
            );
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = CommonUtils.getAppThemeColor(widget.appType);
    final logo = CommonUtils.getAppLogo(widget.appType);

    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is ProfileLoadedSuccess) {
            final user = context.read<AuthCubit>().currentUser;
            if (user == null) return;
            final page = switch (widget.appType) {
              AppType.feed => 0,
              AppType.veterinary => 1,
              AppType.farm => 2,
              AppType.community => 3,
            };

            ref.read(selectedAppbarItem.notifier).state = page;
            context.read<FeedBottomNavCubit>().changeTab(page);
            if (!context.mounted) return;
            ref.read(authProvider.notifier).updateUserFromCubit(user);

            AuthUtils.showNearbyStations(context, initPage: page);
            setState(() {
              isTryingPhoneLogin = false;
              isTryingEmailLogin = false;
            });
          } else if (state is AuthError) {
            if (isTryingPhoneLogin || isTryingEmailLogin) {
              if (state.message.toString().contains('Email not verified')) {
                await showVerifyEmailDialog(context, emailController.text);
              } else {
                ErrorHandler.handleError(context, state.message);
              }
              setState(() {
                isTryingPhoneLogin = false;
                isTryingEmailLogin = false;
              });
            }
          }
        },
        child: DefaultTabController(
          length: 2,
          child: WillPopScope(
              onWillPop: () async {
                if (widget.isNotFromStart) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LandingPage()),
                    (route) => false,
                  );
                  return false;
                } else {
                  Navigator.pop(context);
                  return false;
                }
              },
              child: Scaffold(
                bottomNavigationBar: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: CustomText(
                      textAlign: TextAlign.center,
                      text: 'All rights reserved. United Feed – 2025',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                body: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: const [0, 0.65],
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [color, Colors.white],
                      ),
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: AssetImage(AppImages.loginBackground),
                      ),
                    ),
                    child: Stack(children: [
                      Column(
                        children: [
                          SizedBox(height: 80),
                          Image.asset(
                            logo,
                            width: 52.77,
                            height: 101.25,
                            fit: BoxFit.contain,
                          ),
                          kHeight20,
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: CustomText(
                                text: 'Welcome to United Feeds!',
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                                color: color,
                                textAlign: TextAlign.center,
                                height: isEnglish ? null : 1.6,
                              )),
                          kHeight5,
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: CustomText(
                                text:
                                    'Feed, Veterinary services, Farm, Community.',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                textAlign: TextAlign.center,
                              )),
                          kHeight20,
                          TabBar(
                            labelPadding: const EdgeInsets.all(0),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 2,
                            indicatorColor: color,
                            labelColor: color,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(text: 'Phone Number'.tr()),
                              Tab(text: 'Email'.tr()),
                            ],
                          ),
                          kHeight10,
                          Expanded(
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: buildPhoneLoginTab(color, logo),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: buildEmailLoginTab(
                                    color,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 60,
                        left: 16,
                        child: IconButton(
                          icon: Icon(
                            isEnglish
                                ? Icons.arrow_back_ios
                                : Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if (widget.isNotFromStart) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const LandingPage()),
                                (route) => false,
                              );
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ])),
              )),
        ));
  }

  Widget buildPhoneLoginTab(Color color, String logo) {
    return Form(
      key: _formKey,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is OtpSentSuccess && !state.isResend) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtpScreen(
                  appType: widget.appType,
                  number: phoneController.text,
                  color: color,
                  logo: logo,
                  countryCode: selectedCountry,
                ),
              ),
            );
          } else if (state is AuthError) {
            if (isTryingPhoneLogin) {
              CustomSnackBar.error(context, state.message.toString());
              setState(() => isTryingPhoneLogin = false);
            }
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kHeight10,
              CustomText(
                text: 'Log in with your phone number'.tr(),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              kHeight20,
              CustomTextFormField(
                onCountryChange: (String countryCode) {
                  selectedCountry = countryCode;
                },
                textDirection: flutter.TextDirection.ltr,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.number,
                maxLength: 9,
                fromLogin: true,
                context: context,
                isPhone: true,
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number'.tr();
                  }
                  if (!RegExp(r'^[5]\d{8}$').hasMatch(value)) {
                    return 'Enter a valid phone number'.tr();
                  }
                  return null;
                },
              ),
              kHeight30,
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading &&
                      !(state is OtpSentSuccess && state.isResend);
                  return CustomButton(
                    isLoading: isLoading,
                    radius: 15,
                    width: double.infinity,
                    height: 55,
                    title: 'Send verification code'.tr(),
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final data = {
                          "phone_number": phoneController.text,
                          "country_code": selectedCountry,
                        };
                        setState(() => isTryingPhoneLogin = true);
                        context.read<AuthCubit>().requestOtp(data);
                      }
                    },
                    color: color,
                  );
                },
              ),
              if (widget.appType == AppType.feed ||
                  widget.appType == AppType.veterinary)
                FeedGuestContinueButton(
                  color: color,
                  appType: widget.appType,
                ),
              SocialLoginSection(
                appType: widget.appType,
                onReturnedFromSignUp: () {
                  if (!mounted) return;
                  setState(() {
                    emailController.clear();
                    passwordController.clear();
                    phoneController.clear();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailLoginTab(Color color) {
    return Form(
      key: _formKeyEmail,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kHeight10,
            CustomText(
              text: 'Log in with email'.tr(),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            kHeight20,
            CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                fromLogin: true,
                context: context,
                hintText: 'Email'.tr(),
                controller: emailController,
                nodeAfter: passwordNode,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email'.tr();
                  } else if (value.isNotEmpty) {
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email'.tr();
                    }
                  }
                  return null;
                }),
            kHeight20,
            CustomTextFormField(
              obscureText: true,
              focusNode: passwordNode,
              keyboardType: TextInputType.text,
              context: context,
              hintText: 'Password'.tr(),
              controller: passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Required".tr();
                } else if (value.length < 6) {
                  return "At least 6 characters".tr();
                }
                return null;
              },
            ),
            kHeight20,
            GestureDetector(
              onTap: () async {
                final list = await resetUserPasswordEmail(context);
                if (list != null && list.first.isNotEmpty) {
                  Map<String, String> data = {"email": list.first};
                  final requestMail =
                      context.read<AuthCubit>().resetUserPasswordEmail(data);
                  await LoadingDialog.show(context, requestMail);
                  final otp =
                      await showVerificationOTPDialog(context, list.first);
                  if (otp == null || otp.isEmpty) return;
                  final otpData = {"otp": otp};
                  data.addEntries(otpData.entries);
                  if (!mounted) return;
                  await enterEmailNewPasswordDialog(
                    context,
                    onSubmit: (newPass) async {
                      if (newPass.isEmpty) return;
                      final passwordData = {"password": newPass};
                      data.addEntries(passwordData.entries);
                      final verifyFuture = context
                          .read<AuthCubit>()
                          .verifyResetUserPassword(data);
                      await LoadingDialog.show(context, verifyFuture);
                    },
                  );
                }
              },
              child: CustomText(
                text: 'Forget Password'.tr(),
                decorationColor: color,
                decoration: TextDecoration.underline,
                color: color,
              ),
            ),
            kHeight20,
            BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              final isLoading = state is AuthLoading;
              return CustomButton(
                isLoading: isLoading,
                radius: 15,
                width: double.infinity,
                height: 55,
                title: 'Send verification code'.tr(),
                onTap: () {
                  if (_formKeyEmail.currentState?.validate() ?? false) {
                    final data = {
                      "email": emailController.text,
                      "password": passwordController.text,
                    };
                    setState(() => isTryingEmailLogin = true);
                    context.read<AuthCubit>().loginWithEmail(data);
                  }
                },
                color: color,
              );
            }),
            if (widget.appType == AppType.feed ||
                widget.appType == AppType.veterinary)
              FeedGuestContinueButton(
                color: color,
                appType: widget.appType,
              ),
            SocialLoginSection(
              appType: widget.appType,
              onReturnedFromSignUp: () {
                if (!mounted) return;
                setState(() {
                  emailController.clear();
                  passwordController.clear();
                  phoneController.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
