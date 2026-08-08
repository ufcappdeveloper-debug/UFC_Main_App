import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/riverpod/sadad/sadad_user_async_riverpod.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/sadad_info_reload_provider.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_back_payment_info.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_functions.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_page_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_widgets.dart';

class CheckoutPaymentMethodRadioCard extends ConsumerWidget {
  const CheckoutPaymentMethodRadioCard({
    super.key,
    this.status,
    this.bankDetails,
    this.walletAmount,
    required this.icon,
    this.sadadUserInfo,
    required this.title,
    this.isSelected = false,
    required this.onPressed,
    required this.constraints,
    required this.paymentOption,
    this.selectedPaymentOption = PaymentOptionsEnum.none,
  });
  final String icon;
  final String title;
  final String? status;
  final bool isSelected;
  final String? walletAmount;
  final VoidCallback onPressed;
  final BoxConstraints constraints;
  final BankDetailsModel? bankDetails;
  final PaymentOptionsEnum paymentOption;
  final PaymentOptionsEnum selectedPaymentOption;
  final AsyncValue<SadadUserInfo?>? sadadUserInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: status == 'DISABLE' || status == 'INACTIVE' ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              (status == 'INACTIVE')
                  ? const Color.fromARGB(255, 236, 236, 236)
                  : Colors.white,
              BlendMode.modulate,
            ),
            child: Column(
              children: [
                if (status == 'DISABLE') ...{
                  Container(),
                } else ...{
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      radioButton(selected: isSelected),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Kanit',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(text: title),
                            if (!isStringEmpty(walletAmount))
                              TextSpan(text: ' ($walletAmount)'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        icon,
                        height: 25,
                        color: _iconColor,
                        colorBlendMode:
                            paymentOption == PaymentOptionsEnum.sadad
                                ? BlendMode.color
                                : null,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                },

                //* Checkout Back Payment Info
                AnimatedSize(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: (selectedPaymentOption == PaymentOptionsEnum.bank &&
                          bankDetails != null)
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child:
                              CheckoutBackPaymentInfo(bankDetails: bankDetails),
                        )
                      : const SizedBox.shrink(),
                ),

                //* Checkout SADAD User Info
                AnimatedSize(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: (selectedPaymentOption == PaymentOptionsEnum.sadad &&
                          sadadUserInfo != null)
                      ? sadadUserInfo!.when(
                          data: (sadadUserData) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: sadadUserInfoWidget(
                              context,
                              sadadUserData,
                              constraints,
                              onPressed: status == "ACTIVE" || status == null
                                  ? () => addOrEditSadadUserInfo(
                                      ref, context, constraints, sadadUserData)
                                  : null,
                            ),
                          ),
                          error: (error, stackTrace) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SadadInfoReloadProvider(
                              onPressed: () => ref
                                  .read(sadadUserAsyncProvider.notifier)
                                  .getSadadUserInfo(),
                            ),
                          ),
                          loading: () => const SizedBox(height: 5),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color? get _iconColor => isSelected
      ? (selectedPaymentOption == PaymentOptionsEnum.mada ||
              selectedPaymentOption == PaymentOptionsEnum.sadad
          ? null
          : primaryColor)
      : Colors.grey;
}
