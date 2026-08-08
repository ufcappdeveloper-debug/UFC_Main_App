import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/feed_old/my_wallet/pages/enter_pin_screen.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_appbar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';

enum PaymentOptions { card, applePay }

class TopUpScreen extends ConsumerStatefulWidget {
  const TopUpScreen({super.key});

  @override
  ConsumerState<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends ConsumerState<TopUpScreen>
    with ScreenEngagementTracker {
  PaymentOptions paymentOption = PaymentOptions.card;
  final TextEditingController topUpAmountController = TextEditingController();
  int selectedIndex = -1;
  final List<double> staticTopUpAmount = [40, 50, 60, 70, 80, 90];

  @override
  void dispose() {
    topUpAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletAmount = ref.watch(authProvider).asData?.value?.walletAmount;
    return Scaffold(
      appBar: CustomAppbar(title: "Top Up"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 133,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/profile/walletcard.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "My Balance",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        CustomText(
                          text: (walletAmount ?? 0).toStringAsFixed(2),
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        // CustomText(
                        //   text: "SAR",
                        //   fontSize: 20,
                        //   fontWeight: FontWeight.w500,
                        //   color: Colors.white,
                        // ),
                        SaudiRiyalIcon(
                          size: 20,
                          color: Colors.white,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    CustomText(
                      text: "You can use this amount when placing a new order",
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              CustomText(
                text: "Top Up Wallet",
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              const SizedBox(
                height: 8,
              ),
              Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: List.generate(
                  staticTopUpAmount.length,
                  (index) => SizedBox(
                    width: 108,
                    height: 47,
                    child: InkWell(
                      onTap: () {
                        if (topUpAmountController.text.trim().isNotEmpty) {
                          topUpAmountController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                        setState(() {
                          selectedIndex = selectedIndex == index ? -1 : index;
                        });
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(3),
                        shadowColor: Colors.black38,
                        color: (index != 5 && selectedIndex == index)
                            ? primaryColor
                            : Colors.white,
                        elevation: 5,
                        child: Center(
                          child: index == 5
                              ? TextField(
                                  controller: topUpAmountController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(right: 5),
                                    border: InputBorder.none,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 3),
                                      child:
                                          //  CustomText(
                                          //   text: "SAR",
                                          //   fontSize: 12,
                                          //   fontWeight: FontWeight.w300,
                                          //   color: Colors.black,
                                          // ),
                                          SaudiRiyalIcon(
                                        size: 12,
                                        color: Colors.black,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                      maxWidth: 50,
                                      maxHeight: 50,
                                    ),
                                  ),
                                  cursorColor: primaryColor,
                                  onChanged: (_) {
                                    if (selectedIndex != -1) {
                                      setState(() {
                                        selectedIndex = -1;
                                      });
                                    }
                                  },
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    CustomText(
                                      text: staticTopUpAmount[index].toString(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    // CustomText(
                                    //   text: "SAR",
                                    //   fontSize: 12,
                                    //   fontWeight: FontWeight.w300,
                                    //   color: selectedIndex == index
                                    //       ? Colors.white
                                    //       : Colors.black,
                                    // ),
                                    SaudiRiyalIcon(
                                      size: 12,
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomText(
                text: "Payment Method",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E3354),
              ),
              const SizedBox(
                height: 30,
              ),
              PaymentMethodOptionsTile(
                title: "Credit / Debit Card Payment",
                paymentOptionObject: paymentOption,
                paymentOptionValue: PaymentOptions.card,
                onChange: (PaymentOptions? value) {
                  setState(() {
                    paymentOption = value!;
                  });
                },
                secondary: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/card_logo/visa_1.png",
                      width: 28.14,
                      height: 20,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    SvgPicture.asset(
                      "assets/images/card_logo/mastercard.svg",
                      width: 24.14,
                      height: 16,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    SvgPicture.asset(
                      "assets/images/card_logo/mada_logo.svg",
                      width: 24.14,
                      height: 16,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              PaymentMethodOptionsTile(
                title: "Apple Pay",
                paymentOptionObject: paymentOption,
                paymentOptionValue: PaymentOptions.applePay,
                onChange: (PaymentOptions? value) {
                  setState(() {
                    paymentOption = value!;
                  });
                },
                secondary: SvgPicture.asset(
                  "assets/images/card_logo/applepay.svg",
                  width: 33,
                  height: 30,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Center(
                child: CustomButton(
                  title: "Top Up Wallet",
                  onTap: () {
                    if (selectedIndex == -1 &&
                        topUpAmountController.text.trim().isEmpty) {
                      CustomSnackBar.error(context, "amount is not selected");
                      return;
                    }
                    double selectedAmount = 0.0;
                    if (selectedIndex != -1) {
                      selectedAmount = staticTopUpAmount[selectedIndex];
                    } else if (topUpAmountController.text.trim().isNotEmpty) {
                      selectedAmount =
                          double.parse(topUpAmountController.text.trim());
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnterPinScreen(
                          selectedAmount: selectedAmount,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethodOptionsTile extends StatelessWidget {
  final String title;
  final Widget? secondary;
  final PaymentOptions paymentOptionObject;
  final PaymentOptions paymentOptionValue;
  final Function(PaymentOptions?) onChange;
  const PaymentMethodOptionsTile(
      {super.key,
      required this.title,
      this.secondary,
      required this.paymentOptionObject,
      required this.paymentOptionValue,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(3),
      shadowColor: Colors.black38,
      color: Colors.white,
      elevation: 5,
      child: RadioListTile<PaymentOptions>.adaptive(
        activeColor: primaryColor,
        title: CustomText(
          text: title,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        secondary: secondary,
        dense: true,
        value: paymentOptionValue,
        groupValue: paymentOptionObject,
        onChanged: onChange,
      ),
    );
  }
}
