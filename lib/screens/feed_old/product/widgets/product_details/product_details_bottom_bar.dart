import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/product/product_future_riverpod.dart';
import 'package:ufc_mobile/riverpod/product/product_riverpod.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signin_page.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_page_delivery_method.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/signin_alert_sheet_for_guest_users.dart';
import 'package:ufc_mobile/screens/feed_old/checkout/pages/checkout_page.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';

class ProductDetailsBottomBar extends ConsumerWidget {
  const ProductDetailsBottomBar({
    super.key,
    required this.canBuy,
    required this.productId,
    required this.qtyController,
    this.isLoyaltyProduct = false,
    required this.onLoyalityProductClaimPressed,
  });
  final bool canBuy;
  final int productId;
  final bool isLoyaltyProduct;
  final TextEditingController qtyController;
  final VoidCallback? onLoyalityProductClaimPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productQty = ref.watch(productProvider).qty;
    final productDetailsProvider =
        ref.watch(getProductDetailsProvider(productId));
    final isAuthorized = ref.watch(authProvider.notifier).isAuthorized();

    Widget child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomButton(
            color: !canBuy
                ? Colors.grey
                : ((productDetailsProvider.value == null ||
                            productDetailsProvider.value?.variants == null ||
                            productDetailsProvider.value!.variants!.isEmpty) ||
                        (productDetailsProvider.value?.variants!.first.stock !=
                                null &&
                            productDetailsProvider
                                    .value!.variants!.first.stock! <=
                                0))
                    ? Colors.grey
                    : null,
            title: ((productDetailsProvider.value == null ||
                        productDetailsProvider.value?.variants == null ||
                        productDetailsProvider.value!.variants!.isEmpty) ||
                    (productDetailsProvider.value?.variants!.first.stock !=
                            null &&
                        productDetailsProvider.value!.variants!.first.stock! <=
                            0))
                ? 'OUT OF STOCK'
                : 'DIRECT BUY',
            onTap: !canBuy
                ? () => CustomSnackBar.error(
                    context, "Purchase available only at preferred shop")
                : ((productDetailsProvider.value == null ||
                            productDetailsProvider.value?.variants == null ||
                            productDetailsProvider.value!.variants!.isEmpty) ||
                        (productDetailsProvider.value?.variants!.first.stock !=
                                null &&
                            productDetailsProvider
                                    .value!.variants!.first.stock! <=
                                0))
                    ? () =>
                        CustomSnackBar.error(context, "Product Out of Stock")
                    : productQty >
                            productDetailsProvider.value!.variants!.first.stock!
                        ? () => CustomSnackBar.error(context,
                            "You can order up to  ${productDetailsProvider.value!.variants!.first.stock} products only!")
                        : () async {
                            if (!isAuthorized) {
                              showUnauthorizedBottomSheet(
                                context,
                                onSignInPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignInPage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              );
                              return;
                            }

                            await deliveryMethod(
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
                                        directBuy: true,
                                        isDelivery: true,
                                        deliveryTime: deliveryTime,
                                        quantity:
                                            int.tryParse(qtyController.text) ??
                                                1,
                                        productItem:
                                            productDetailsProvider.value,
                                      ),
                                    ),
                                  ).then(
                                    (value) {
                                      if (!context.mounted) return;
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                }
                              },
                              onPickUpPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(
                                    directBuy: true,
                                    productItem: productDetailsProvider.value,
                                    quantity: int.parse(qtyController.text),
                                  ),
                                ),
                              ).then(
                                (value) {
                                  if (!context.mounted) return;
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            );
                          },
            radius: 10,
            height: 42,
            fontSize: 12,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15),
          child: InkWell(
            onTap: !canBuy ||
                    productDetailsProvider.value == null ||
                    productDetailsProvider.isLoading ||
                    productDetailsProvider.hasError
                ? () => CustomSnackBar.error(
                    context, "Purchase available only at preferred shop")
                : ((productDetailsProvider.value == null ||
                            productDetailsProvider.value?.variants == null ||
                            productDetailsProvider.value!.variants!.isEmpty) ||
                        (productDetailsProvider.value?.variants!.first.stock !=
                                null &&
                            productDetailsProvider
                                    .value!.variants!.first.stock! <=
                                0))
                    ? () =>
                        CustomSnackBar.error(context, "Product Out of Stock")
                    : () async {
                        final product = productDetailsProvider.value!;
                        final variant = product.variants!.first;
                        final stock = variant.stock ?? 0;
                        final existingItem =
                            ref.read(cartProvider).cartItems.firstWhere(
                                  (item) => item.variant?.id == variant.id,
                                  orElse: () => CartItemModel(quantity: 0),
                                );

                        final currentCartQuantity = existingItem.quantity ?? 0;

                        if (currentCartQuantity >= stock) {
                          // CustomSnackBar.error(context,
                          // "You can order up to ${stock - currentCartQuantity} more of this product.");
                          CustomSnackBar.error(
                              context, "Stock limit reached. Cannot add more.");
                          return;
                        }

                        //   :
                        //  productQty >
                        //           productDetailsProvider.value!.variants!.first.stock!
                        //       ? () => CustomSnackBar.error(context,
                        //           "${'You can order up to'.tr()}  ${productDetailsProvider.value!.variants!.first.stock} ${'products only!'.tr()}")
                        //       : () async {

                        if (!isAuthorized) {
                          showUnauthorizedBottomSheet(
                            context,
                            onSignInPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInPage(),
                                ),
                                (route) => false,
                              );
                            },
                          );
                          return;
                        }

                        if (productDetailsProvider.value == null ||
                            productDetailsProvider.value?.variants == null ||
                            productDetailsProvider.value!.variants!.isEmpty) {
                          CustomSnackBar.error(context,
                              "Something went wrong, please contact admin");
                          return;
                        }

                        final int requestedQty =
                            int.tryParse(qtyController.text) ?? 0;
                        final int remainingStock = stock - currentCartQuantity;

                        if (requestedQty > remainingStock) {
                          CustomSnackBar.error(
                            context,
                            "You can order up to $remainingStock more of this product.",
                          );
                          return;
                        }
                        final Map<String, dynamic> data = {
                          "quantity": int.parse(qtyController.text),
                          "variant_id":
                              productDetailsProvider.value?.variants?.first.id,
                          "product_id": productDetailsProvider.value?.id,
                        };
                        try {
                          final future = ref.read(cartProvider).addToCart(data);
                          final result =
                              await LoadingDialog.show(context, future);
                          if (context.mounted && (result)) {
                            CustomSnackBar.success(
                                context, "Item added to cart successfully");
                            ref.read(cartProvider).getCartItems();
                          }
                        } catch (e) {
                          if (!context.mounted) return;
                          CustomSnackBar.error(context, e.toString());
                        }
                      },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Image.asset(
              'assets/images/product/add_to_cart.png',
              height: 45,
              color: !canBuy
                  ? Colors.grey
                  : ((productDetailsProvider.value == null ||
                              productDetailsProvider.value?.variants == null ||
                              productDetailsProvider
                                  .value!.variants!.isEmpty) ||
                          (productDetailsProvider
                                      .value?.variants!.first.stock !=
                                  null &&
                              productDetailsProvider
                                      .value!.variants!.first.stock! <=
                                  0))
                      ? Colors.grey
                      : null,
            ),
          ),
        ),
      ],
    );

    if (isLoyaltyProduct) {
      child = CustomButton(
        radius: 10,
        height: 42,
        fontSize: 12,
        title: 'ADD TO CART',
        color: !canBuy ? Colors.grey : null,
        onTap: !canBuy
            ? () => CustomSnackBar.error(
                context, "Purchase available only at preferred shop")
            : !isAuthorized
                ? () => showUnauthorizedBottomSheet(
                      context,
                      onSignInPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                          (route) => false,
                        );
                      },
                    )
                : onLoyalityProductClaimPressed,
      );
    }

    return Container(
      height: 93,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 15,
              spreadRadius: 0,
              offset: Offset(0, 0),
              color: Color.fromRGBO(0, 0, 0, 0.08)),
        ],
      ),
      padding: const EdgeInsetsDirectional.only(end: 5, start: 20),
      child: child,
    );
  }
}
