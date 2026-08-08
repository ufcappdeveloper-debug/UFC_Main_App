import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/currency/currency_riverpod.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_page_delivery_method.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/pages/checkout_page.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class CartPageBottomBtnSection extends ConsumerWidget {
  const CartPageBottomBtnSection({
    super.key,
    this.isPush = false,
  });
  final bool isPush;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider).cartItems;
    final currencyData = ref.watch(currencyProvider).selectedCurrency;
    final isAuthorized = ref.read(authProvider.notifier).isAuthorized();
    final currencyRate = ref.watch(currencyProvider).selectedCurrencyRate ?? 1;
    final recalculatedCartTotal = ref.watch(cartProvider).recalculatedCartTotal;

    if (!isAuthorized) {
      return SizedBox.shrink();
    }

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        constraints: const BoxConstraints(minHeight: 110),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFE4E4E4),
              offset: Offset(0, 4),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: "Total Amount",
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: AnimatedDigitWidget(
                    value: (recalculatedCartTotal * currencyRate),
                    fractionDigits: 2,
                    enableSeparator: true,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                (currencyData?.code == "SAR")
                    ? const SaudiRiyalIcon(size: 12)
                    : CustomText(
                        text: " ${currencyData?.code ?? 'SAR'}",
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        textAlign: TextAlign.end,
                      ),
              ],
            ),
            const SizedBox(height: 18),
            CustomButton(
              height: 48,
              title: 'Checkout',
              width: double.infinity,
              color: cartItems.isEmpty ? Colors.grey : primaryColor,
              onTap: cartItems.isEmpty
                  ? () {}
                  : () async => deliveryMethod(
                        context,
                        onDeliveryPressed: () async {
                          DateTime? deliveryTime =
                              await showTimeBookingPopup(context);
                          if (deliveryTime != null) {
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  isDelivery: true,
                                  deliveryTime: deliveryTime,
                                  cartItems: cartItems,
                                ),
                              ),
                            ).then((value) {
                              ref.read(cartProvider).getCartItems();
                              if (!context.mounted) return;
                              if (Navigator.canPop(context)) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        onPickUpPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckoutPage(cartItems: cartItems),
                          ),
                        ).then((value) {
                          ref.read(cartProvider).getCartItems();
                          if (!context.mounted) return;
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          }
                        }),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
