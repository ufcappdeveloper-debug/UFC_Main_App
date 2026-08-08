import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/app_setting/app_setting_riverpod.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/sadad/sadad_user_async_riverpod.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_page_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_payment_method_check_card.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_payment_method_radio_card.dart';

class CheckoutPaymentMethod extends ConsumerWidget {
  const CheckoutPaymentMethod({
    super.key,
    required this.subTotal,
    this.isDelivery = false,
    required this.constraints,
    this.isWalletChecked = false,
    required this.onWalletChanged,
    required this.selectedPaymentOption,
    required this.onSelectedPaymentOptionChanged,
  });
  final bool isDelivery;
  final double subTotal;
  final bool isWalletChecked;
  final BoxConstraints constraints;
  final Function(bool value) onWalletChanged;
  final PaymentOptionsEnum selectedPaymentOption;
  final Function(PaymentOptionsEnum paymentOption)
      onSelectedPaymentOptionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sadadUserInfo = ref.watch(sadadUserAsyncProvider);
    final bankDetails = ref.watch(paymentMethodProvider).bankDetails;
    final appSettings = ref.watch(appSettingRiverpodProvider).asData?.value;
    final walletAmount = ref.watch(authProvider).asData?.value?.walletAmount;

    // Check for null before accessing keys
    final madaStatus = appSettings?['MADA_STATUS'];
    final bankStatus = appSettings?['BANK_STATUS'];
    final sadadStatus = appSettings?['SADAD_STATUS'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        checkoutTitle(title: 'Payment Method'),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Pay with Wallet
              CheckoutPaymentMethodCheckCard(
                isSelected: isWalletChecked,
                title: "Pay with Wallet".tr(),
                icon: 'assets/images/profile/wallet.png',
                walletAmount: walletAmount?.toStringAsFixed(2),
                onPressed: () {
                  if (isWalletChecked) {
                    onWalletChanged(false);
                    if (selectedPaymentOption == PaymentOptionsEnum.wallet) {
                      onSelectedPaymentOptionChanged(PaymentOptionsEnum.none);
                    }
                  } else {
                    onWalletChanged(true);
                    if (selectedPaymentOption == PaymentOptionsEnum.none) {
                      onSelectedPaymentOptionChanged(PaymentOptionsEnum.wallet);
                    }
                  }
                },
              ),

              //* Pay with SADAD
              if (sadadStatus == 'ACTIVE' || sadadStatus == 'INACTIVE')
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CheckoutPaymentMethodRadioCard(
                    status: sadadStatus,
                    constraints: constraints,
                    title: 'Pay with SADAD'.tr(),
                    sadadUserInfo: sadadUserInfo,
                    icon: 'assets/images/global/sadad.png',
                    paymentOption: PaymentOptionsEnum.sadad,
                    selectedPaymentOption: selectedPaymentOption,
                    isSelected: (sadadStatus == 'INACTIVE')
                        ? false
                        : selectedPaymentOption == PaymentOptionsEnum.sadad,
                    onPressed: () {
                      if (sadadStatus != "INACTIVE" &&
                          sadadStatus != "DISABLE") {
                        if (selectedPaymentOption == PaymentOptionsEnum.sadad) {
                          onSelectedPaymentOptionChanged(PaymentOptionsEnum
                              .none); // Deselect if already selected
                        } else {
                          onSelectedPaymentOptionChanged(
                              PaymentOptionsEnum.sadad);
                        }
                      }
                    },
                  ),
                ),

              //* Pay with Bank
              if (bankStatus == 'ACTIVE' && bankDetails != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CheckoutPaymentMethodRadioCard(
                    status: bankStatus,
                    constraints: constraints,
                    bankDetails: bankDetails,
                    title: 'Pay with Bank'.tr(),
                    icon: 'assets/images/payment/bank.png',
                    paymentOption: PaymentOptionsEnum.bank,
                    selectedPaymentOption: selectedPaymentOption,
                    isSelected:
                        selectedPaymentOption == PaymentOptionsEnum.bank,
                    onPressed: () {
                      if (selectedPaymentOption == PaymentOptionsEnum.bank) {
                        onSelectedPaymentOptionChanged(PaymentOptionsEnum.none);
                      } else {
                        onSelectedPaymentOptionChanged(PaymentOptionsEnum.bank);
                      }
                    },
                  ),
                ),

              //* Pay with MADA
              if (madaStatus == 'ACTIVE')
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CheckoutPaymentMethodRadioCard(
                    status: madaStatus,
                    constraints: constraints,
                    title: 'Pay with MADA'.tr(),
                    icon: 'assets/images/cart/mada_logo.png',
                    paymentOption: PaymentOptionsEnum.mada,
                    selectedPaymentOption: selectedPaymentOption,
                    isSelected:
                        selectedPaymentOption == PaymentOptionsEnum.mada,
                    onPressed: () {
                      if (selectedPaymentOption == PaymentOptionsEnum.mada) {
                        onSelectedPaymentOptionChanged(PaymentOptionsEnum.none);
                      } else {
                        onSelectedPaymentOptionChanged(PaymentOptionsEnum.mada);
                      }
                    },
                  ),
                ),

              /* NOTE: APPLE PAY WIDGET HIDDEN */
              /* Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 3;
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      radioButton(selected: selectedIndex == 3),
                                      CustomText(
                                        text: 'Apple Pay',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const Spacer(),
                                      Image.asset('assets/images/cart/apple_pay.png',
                                          height: 33),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              ), */

              // * Cash on Pickup
              if (!isDelivery)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CheckoutPaymentMethodRadioCard(
                    constraints: constraints,
                    title: 'Pay at the station'.tr(),
                    paymentOption: PaymentOptionsEnum.cash,
                    icon: 'assets/images/cart/cod_hand.png',
                    isSelected:
                        selectedPaymentOption == PaymentOptionsEnum.cash,
                    onPressed: () {
                      if (selectedPaymentOption == PaymentOptionsEnum.cash) {
                        onSelectedPaymentOptionChanged(PaymentOptionsEnum.none);
                      } else {
                        onSelectedPaymentOptionChanged(PaymentOptionsEnum.cash);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
