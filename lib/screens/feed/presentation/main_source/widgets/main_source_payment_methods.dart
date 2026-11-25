import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/enum/payment_option.dart';

import '../../../application/checkout/sadad/sadad_cubit.dart';
import '../../../application/checkout/sadad/sadad_state.dart';
import '../../../domain/entities/checkout/sadad/sadad_user_info.dart';
import '../../../domain/entities/main_source/main_source_model.dart';
import '../../../domain/entities/main_source/main_source_quote_model.dart';
import '../../checkout/widgets/feed_checkout_payment_method_check_card.dart';
import '../../checkout/widgets/feed_checkout_payment_method_radio_card.dart';
import '../../distributor/utils/distributor_style.dart';
import '../../distributor/widgets/distributor_common_widgets.dart';

PaymentOptionsEnum paymentOptionOf(String? code) =>
    PaymentOptionsEnum.values.firstWhere((o) => o.getValue == code,
        orElse: () => PaymentOptionsEnum.none);

/// Wallet checkbox + radio buttons, built from the same cards as
/// `FeedCheckoutPaymentMethod`, but driven only by the quote's
/// `payment_methods` (plan §4.3), never by SADAD_STATUS / MADA_STATUS.
class MainSourcePaymentMethods extends StatelessWidget {
  final MainSourceQuoteModel quote;
  final bool useWallet;
  final String? selected;
  final ValueChanged<bool> onWalletChanged;
  final ValueChanged<String?> onSelected;

  const MainSourcePaymentMethods({
    super.key,
    required this.quote,
    required this.useWallet,
    required this.selected,
    required this.onWalletChanged,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selectedOption = paymentOptionOf(selected);
    final sadadInfo = context.select<SadadUserInfoCubit, SadadUserInfo?>((c) =>
        c.state is SadadLoaded ? (c.state as SadadLoaded).userInfo : null);
    return LayoutBuilder(builder: (context, constraints) {
      Widget radio(String code, String title, String icon,
          {bool enabled = true, String? hint}) {
        final option = paymentOptionOf(code);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeedCheckoutPaymentMethodRadioCard(
              constraints: constraints,
              title: title.tr(),
              icon: icon,
              status: enabled ? 'ACTIVE' : 'INACTIVE',
              paymentOption: option,
              selectedPaymentOption: selectedOption,
              isSelected: selectedOption == option,
              isSadad: option == PaymentOptionsEnum.sadad,
              sadadUserInfo:
                  option == PaymentOptionsEnum.sadad ? sadadInfo : null,
              onPressed: () => onSelected(selectedOption == option ? null : code),
            ),
            if (hint != null)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(52, 0, 16, 6),
                child: Text(hint,
                    style: DistributorStyle.style(
                        size: 11, color: DistributorStyle.error)),
              ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: CustomText(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                text: 'Payment Method'),
          ),
          const SizedBox(height: 8),
          if (quote.canUseWallet)
            FeedCheckoutPaymentMethodCheckCard(
              isSelected: useWallet,
              title: 'Use wallet balance'.tr(),
              icon: 'assets/images/profile/wallet.png',
              walletAmount: quote.walletBalance.toStringAsFixed(2),
              onPressed: () => onWalletChanged(!useWallet),
            ),
          if (useWallet && quote.walletApplied > 0 && quote.payableAmount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Flexible(
                    child: Text('Remaining amount to be paid'.tr(),
                        style: DistributorStyle.style(
                            size: 12, color: DistributorStyle.textSecondary)),
                  ),
                  const SizedBox(width: 6),
                  RiyalAmount(quote.payableAmount, size: 12),
                ],
              ),
            ),
          if (quote.offers(MainSourcePaymentMethod.cash))
            radio(MainSourcePaymentMethod.cash, 'Cash on delivery',
                'assets/images/cart/cod_hand.png'),
          if (quote.offers(MainSourcePaymentMethod.mada))
            radio(MainSourcePaymentMethod.mada, 'Pay with MADA',
                'assets/images/cart/mada_logo.png'),
          if (quote.offers(MainSourcePaymentMethod.sadad))
            radio(MainSourcePaymentMethod.sadad, 'Pay with SADAD',
                'assets/images/global/sadad.png',
                enabled: quote.sadadAllowed,
                hint: quote.sadadAllowed
                    ? null
                    : 'ms_sadad_min_amount'.tr(namedArgs: {
                        'sadad_min_amount':
                            quote.sadadMinAmount.toStringAsFixed(2)
                      })),
          if (quote.offers(MainSourcePaymentMethod.bank))
            radio(MainSourcePaymentMethod.bank, 'Bank Transfer',
                'assets/images/payment/bank.png'),
          if (quote.offers(MainSourcePaymentMethod.wallet))
            radio(MainSourcePaymentMethod.wallet, 'Pay with Wallet',
                'assets/images/profile/wallet.png',
                enabled: quote.walletCoversTotal,
                hint: quote.walletCoversTotal
                    ? null
                    : 'Your wallet balance is not enough for this order.'.tr()),
        ],
      );
    });
  }
}
