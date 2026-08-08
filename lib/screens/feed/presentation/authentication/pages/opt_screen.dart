import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/feed_auth_utils.dart';

import '../../../../../global/extensions/app_images.dart';
import '../../../../../global/shared/widgets/custom_button.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../../global/util/common/common_utils.dart';
import '../../../../../riverpod/app_bar/app_bar_riverpod.dart';
import '../../../../../riverpod/auth/auth.dart';
import '../../../application/authentication/auth_cubit.dart';
import '../../../application/bottom_bar_bloc/bottom_bar_bloc.dart';
import '../../../domain/entities/authentication/user_model.dart';

class OtpScreen extends StatefulWidget {
  final Color color;
  final String logo;
  final String number;
  final AppType appType;
  final String countryCode;
  const OtpScreen({
    super.key,
    required this.color,
    required this.logo,
    required this.number,
    required this.appType,
    required this.countryCode,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer timer;
  int secondsRemaining = 60;
  bool canResend = false;
  late TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
    startTimer();
  }

  void startTimer() {
    setState(() {
      secondsRemaining = 60;
      canResend = false;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void navigate(WidgetRef ref, BuildContext context, UserModel user) async {
    final page = getPage();
    ref.read(selectedAppbarItem.notifier).state = page;
    context.read<FeedBottomNavCubit>().changeTab(page);
    if (!context.mounted) return;
    ref.read(authProvider.notifier).updateUserFromCubit(user);
    AuthUtils.showNearbyStations(context, ref: ref, initPage: page);

    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => BottomBar(initialAppIndex: page)),
    //     (route) => false);
  }

  int getPage() {
    return switch (widget.appType) {
      AppType.feed => 0,
      AppType.veterinary => 1,
      AppType.farm => 2,
      AppType.community => 3,
    };
  }

  String get timerText {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomText(
            textAlign: TextAlign.center,
            text: 'All rights reserved. United Feed – 2025',
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0, 0.65],
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [widget.color, Colors.white],
          ),
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(AppImages.loginBackground),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.logo,
              width: 52.77,
              height: 101.25,
              fit: BoxFit.contain,
            ),
            kHeight35,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Code verification',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  CustomText(
                    text:
                        '${'Please enter the verification code sent to your mobile phone'.tr()} *******${widget.number.substring(7)}',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  kHeight20,
                  Center(
                    child: GestureDetector(
                      onTap: canResend
                          ? () {
                              startTimer();
                              final data = {
                                "phone_number": widget.number,
                                "country_code": widget.countryCode
                              };
                              context
                                  .read<AuthCubit>()
                                  .requestOtp(data, isResend: true);
                            }
                          : () {},
                      child: CustomText(
                        text: canResend ? "Resend".tr() : timerText,
                        color: widget.color,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  kHeight20,
                  Center(
                    child: Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Pinput(
                        length: 6,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        defaultPinTheme: PinTheme(
                          width: 55,
                          height: 55,
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 55,
                          height: 55,
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          decoration: BoxDecoration(
                            border: Border.all(color: widget.color),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  kHeight30,
                  Consumer(
                    builder: (context, ref, child) {
                      return BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is OtpVerifiedSuccess) {
                            navigate(ref, context, state.user);
                          } else if (state is AuthError) {
                            otpController.clear();
                            CustomSnackBar.error(
                                context, state.message.toString());
                          }
                        },
                        builder: (context, state) {
                          return CustomButton(
                            isLoading: state is AuthLoading && !state.isResend,
                            radius: 15,
                            width: double.infinity,
                            height: 55,
                            title: 'Continue'.tr(),
                            onTap: () {
                              if (otpController.length == 6) {
                                final data = {
                                  "phone_number": widget.number,
                                  "country_code": widget.countryCode,
                                  "otp": otpController.text
                                };
                                context.read<AuthCubit>().verifyOtp(data);
                              } else {
                                CustomSnackBar.error(
                                    context, "verification code incomplete");
                              }
                            },
                            color: widget.color,
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
