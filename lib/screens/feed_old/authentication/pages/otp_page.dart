import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/feed_auth_utils.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/utils/sms_retriever_impl.dart';

import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../global/shared/widgets/loading/loading_dialog.dart';
import '../../../../riverpod/auth/auth.dart';

class OTPPage extends ConsumerStatefulWidget {
  const OTPPage({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
  });
  final String countryCode;
  final String phoneNumber;

  @override
  ConsumerState<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends ConsumerState<OTPPage> {
  late Timer t;
  late final SmsRetrieverImpl smsRetrieverImpl;
  final ValueNotifier<int> countDown = ValueNotifier(30);
  TextEditingController pinController = TextEditingController();
  final pinTheme = const PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold));

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      pinController.text = '123456';
    }

    smsRetrieverImpl = SmsRetrieverImpl(SmartAuth.instance);

    startTimer();
  }

  void startTimer() {
    countDown.value = 30;
    t = Timer.periodic(const Duration(seconds: 1), (timer) {
      countDown.value -= 1;
      debugPrint(countDown.value.toString());
      if (countDown.value <= 0 && t.isActive) {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    t.cancel();
    countDown.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomText(
                  text: 'OTP Verification',
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomText(
                  text:
                      'Thank you for registering with us. Please type the OTP sent to your mobile',
                  fontSize: 15,
                  textAlign: TextAlign.center,
                  color: const Color(0xff939393),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomText(
                  text:
                      'xxxxxxxx${widget.phoneNumber.substring((widget.phoneNumber.length) - 2)}',
                  fontSize: 15,
                  color: const Color(0xff939393),
                ),
              ),
              const SizedBox(height: 43),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: SizedBox(
                  height: 70,
                  child: Pinput(
                    length: 6,
                    autofocus: true,
                    controller: pinController,
                    smsRetriever: smsRetrieverImpl,
                    defaultPinTheme: pinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: const Color(0xFF6C6A6A)),
                      ),
                    ),
                    focusedPinTheme: pinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                ),
              ), // end onSubmit
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'OTP not received? ',
                          fontSize: 11,
                          color: const Color(0xFF747474),
                        ),
                        ValueListenableBuilder(
                          valueListenable: countDown,
                          builder: (context, int value, _) => value <= 0
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: primaryColor),
                                  onPressed: () async {
                                    try {
                                      final data = {
                                        "country_code": widget.countryCode,
                                        "phone_number": widget.phoneNumber
                                            .replaceAll(" ", ""),
                                      };

                                      final future = ref
                                          .read(authProvider.notifier)
                                          .requestOtp(data);
                                      await LoadingDialog.show(context, future);
                                      startTimer();
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      CustomSnackBar.error(
                                          context, e.toString());
                                    }
                                  },
                                  child: CustomText(
                                    fontSize: 15,
                                    text: 'Resend',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : TextButton(
                                  onPressed: null,
                                  child: CustomText(
                                    fontSize: 15,
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w600,
                                    text: '${"Resend".tr()} $value',
                                    decorationColor: mediumGreenColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                        ),
                      ])),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomButton(
                  height: 42,
                  title: 'Submit',
                  onTap: () async {
                    if (pinController.text.length == 6) {
                      final otp = pinController.text;
                      final countryCode = widget.countryCode;
                      final phoneNumber =
                          widget.phoneNumber.replaceAll(" ", "");

                      if (isStringEmpty(otp) ||
                          isStringEmpty(countryCode) ||
                          isStringEmpty(phoneNumber)) {
                        CustomSnackBar.error(context,
                            'Invalid OTP. Please check and try again.');
                        return;
                      }

                      try {
                        final future = ref
                            .read(authProvider.notifier)
                            .verifyOtp(
                                otp: otp,
                                countryCode: countryCode,
                                phoneNumber: phoneNumber);
                        await LoadingDialog.show(context, future);

                        if (!context.mounted) return;
                        AuthUtils.showNearbyStations(context, ref: ref);
                      } catch (e) {
                        if (!mounted) return;
                        CustomSnackBar.error(context, e.toString());
                      }
                    } else {
                      CustomSnackBar.error(
                          context, "verification code incomplete");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
