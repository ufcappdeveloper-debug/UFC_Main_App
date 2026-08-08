import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_functions.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_page_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';

class FeedCheckoutPaymentMethodRadioCard extends StatelessWidget {
  const FeedCheckoutPaymentMethodRadioCard({
    super.key,
    this.status,
    this.bankDetails,
    this.walletAmount,
    required this.icon,
    this.sadadUserInfo,
    required this.title,
    this.isSelected = false,
    required this.onPressed,
    this.isSadad = false,
    required this.constraints,
    required this.paymentOption,
    this.selectedPaymentOption = PaymentOptionsEnum.none,
  });
  final String icon;
  final String title;
  final String? status;
  final bool isSelected;
  final bool isSadad;
  final String? walletAmount;
  final VoidCallback onPressed;
  final BoxConstraints constraints;
  final BankDetailsModel? bankDetails;
  final PaymentOptionsEnum paymentOption;
  final PaymentOptionsEnum selectedPaymentOption;
  final SadadUserInfo? sadadUserInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: (isSelected && isSadad)
              ? primaryColor.withAlpha(20)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color:
                  (isSelected && isSadad) ? primaryColor : Colors.transparent)),
      child: InkWell(
        onTap: status == 'DISABLE' || status == 'INACTIVE' ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
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
                            fontFamily: isEnglish
                                ? AppFontsFamily.english
                                : AppFontsFamily.arabic,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: title,
                            ),
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
                      paymentOption == PaymentOptionsEnum.sadad ||
                              paymentOption == PaymentOptionsEnum.mada
                          ? SizedBox.shrink()
                          : SizedBox(width: 10),
                    ],
                  ),
                },

                //* Checkout SADAD User Info (only render if provided)
                AnimatedSize(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: (paymentOption == PaymentOptionsEnum.sadad &&
                          selectedPaymentOption == PaymentOptionsEnum.sadad)
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: sadadUserInfoWidget(
                            context,
                            sadadUserInfo, // can be null
                            constraints,
                            onPressed: (status == "ACTIVE" || status == null)
                                ? () => addOrEditSadadUserInfo(
                                    context, constraints, sadadUserInfo)
                                : null,
                          ),
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

  Color? get _iconColor => (selectedPaymentOption == PaymentOptionsEnum.mada ||
          selectedPaymentOption == PaymentOptionsEnum.sadad
      ? null
      : null);
}
