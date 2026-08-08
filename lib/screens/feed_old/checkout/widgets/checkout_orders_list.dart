import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/riverpod/currency/currency_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_page_widgets.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/widgets/checkout_widgets.dart';

class CheckoutOrdersList extends ConsumerWidget {
  const CheckoutOrdersList({
    super.key,
    required this.quantity,
    required this.cartItems,
    required this.productItem,
  });
  final int quantity;
  final ProductModel? productItem;
  final List<CartItemModel>? cartItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyData = ref.watch(currencyProvider).selectedCurrency;
    final currencyRate = ref.watch(currencyProvider).selectedCurrencyRate ?? 1;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          checkoutTitle(
              title: 'Your Order',
              itemCount: '$cartItemsLength ${"Items".tr()}',
              margin: EdgeInsets.zero),
          const SizedBox(height: 20),
          if (productItem != null)
            checkoutItem(
              context,
              quantity: quantity,
              productItem: productItem,
              currencyData: currencyData,
              currencyRate: currencyRate,
            ),
          if (cartItems != null)
            ...cartItems!.map(
              (item) {
                int index = cartItems!.indexOf(item);
                return Column(
                  children: [
                    checkoutItem(
                      context,
                      cartItem: item,
                      currencyData: currencyData,
                      currencyRate: currencyRate,
                    ),
                    index + 1 != cartItems!.length
                        ? const Divider(
                            color: Color.fromRGBO(234, 234, 234, 1),
                            thickness: 1,
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  int get cartItemsLength {
    if (productItem != null) return 1;
    if (cartItems != null && cartItems!.isNotEmpty) {
      return cartItems?.length ?? 0;
    }
    return 0;
  }
}
