import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/transactions/transactions_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_appbar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../riverpod/transactions/recent_transactions_provider.dart';
import '../../../../global/shared/constants/app_colors.dart';
import '../../../../global/shared/widgets/custom_button.dart';

class EnterPinScreen extends ConsumerStatefulWidget {
  final double selectedAmount;
  const EnterPinScreen({super.key, required this.selectedAmount});

  @override
  ConsumerState<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends ConsumerState<EnterPinScreen>
    with ScreenEngagementTracker {
  TextEditingController pinController = TextEditingController();
  final pinTheme = const PinTheme(
    width: 50,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 12),
    textStyle: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Enter Your Pin"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              CustomText(
                text: "Enter your pin to confirm top up",
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: const Color(0xFF838383),
              ),
              const SizedBox(
                height: 54,
              ),
              Pinput(
                controller: pinController,
                length: 4,
                autofocus: true,
                obscureText: true,
                obscuringWidget: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: primaryColor),
                ),
                defaultPinTheme: pinTheme.copyWith(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.all(
                      Radius.circular(9),
                    ),
                  ),
                ),
                focusedPinTheme: pinTheme.copyWith(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(9),
                    ),
                    border: Border.all(
                      color: primaryColor,
                      width: 2,
                    ),
                  ),
                ), // end onSubmit
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              CustomButton(
                title: "Continue",
                onTap: () async {
                  if (pinController.text.isEmpty) {
                    CustomSnackBar.error(context, "Please enter your pin");
                    return;
                  }
                  final data = {
                    "amount": widget.selectedAmount,
                    "type": "ADDITION"
                  };
                  final future = ref
                      .read(transactionsProvider.notifier)
                      .updateWallet(data);
                  try {
                    await LoadingDialog.show(context, future);
                    if (mounted) {
                      if (!context.mounted) return;
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 56,
                              ),
                              CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 60,
                                child: SvgPicture.asset(
                                  "assets/images/profile/check.svg",
                                  width: 44,
                                  height: 32,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomText(
                                text: "Top Up successful !",
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              CustomText(
                                text:
                                    "${"You have successfully top up\ne- wallet fo SAR".tr()}${widget.selectedAmount}",
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                                color: const Color(0xFF848484),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 100,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 26.0),
                                child: CustomButton(
                                    title: "OK",
                                    onTap: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                              const SizedBox(
                                height: 39,
                              ),
                            ],
                          ),
                        ),
                      );
                      await ref
                          .read(authProvider.notifier)
                          .updateWalletAmount(widget.selectedAmount);

                      // ignore: unused_result
                      ref.refresh(recentTransactionsProvider);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    CustomSnackBar.error(context, e.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
