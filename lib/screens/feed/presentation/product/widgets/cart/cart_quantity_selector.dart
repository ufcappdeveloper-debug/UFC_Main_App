import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/cart/feed_cart_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

class CartQuantitySelector extends StatelessWidget {
  final int qty;
  final int itemId;
  final bool isWide;
  final bool isSmall;

  const CartQuantitySelector(
      {super.key,
      required this.qty,
      required this.itemId,
      required this.isWide,
      required this.isSmall});

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartCubit>().state;

    int availableStock = 0;
    if (cartState is CartLoaded) {
      final item = cartState.cartItems.firstWhere(
        (i) => i.id == itemId,
        orElse: () => FeedCartItemModel(),
      );
      availableStock = item.variant?.stock ?? 0;
    }

    final canDecrease = qty > 1;
    final canIncrease = availableStock >= 0 ? qty < availableStock : true;

    final isUpdating =
        cartState is CartLoaded && cartState.updatingItemIds.contains(itemId);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: PetVeterinaryShadows.standardLight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            /// ➖ Decrease button
            GestureDetector(
              onTap: (canDecrease && !isUpdating)
                  ? () async {
                      await context.read<CartCubit>().decrementQuantity(itemId);
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: canDecrease ? const Color(0xFF78B943) : Colors.grey,
                  shape: BoxShape.circle,
                ),
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: const Icon(Icons.remove, color: Colors.white, size: 16),
              ),
            ),

            /// Quantity label
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: qty > 99
                    ? (isWide
                        ? 18.0
                        : isSmall
                            ? 8
                            : 12.0)
                    : (isWide
                        ? 18.0
                        : isSmall
                            ? 12
                            : 16.0),
              ),
              child: Builder(builder: (context) {
                final text = "$qty ${qty > 1 ? 'Bags'.tr() : 'Bag'.tr()}";
                final fontSize = isWide ? 15.0 : 13.0;

                // --- Measure the width of the text ---
                final textPainter = TextPainter(
                  text: TextSpan(
                    text: text,
                    style: TextStyle(fontSize: fontSize),
                  ),
                  maxLines: 1,
                  textDirection: ui.TextDirection.ltr,
                )..layout();

                final textWidth = textPainter.size.width;

                // ---------------------------------------------------

                if (isUpdating) {
                  return SizedBox(
                    width: textWidth,
                    height: fontSize + 4, // slight padding
                    child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: fontSize + 4,
                        color: Colors.black,
                      ),
                    ),
                  );
                }

                return CustomText(
                  text: text,
                  fontSize: fontSize,
                );
              }),
            ),

            /// ➕ Increase button
            GestureDetector(
              onTap: (canIncrease && !isUpdating)
                  ? () async {
                      await context.read<CartCubit>().incrementQuantity(itemId);
                    }
                  : () {
                      CustomSnackBar.error(
                        context,
                        isEnglish
                            ? "Only $availableStock item${availableStock == 1 ? '' : 's'} available in stock"
                            : (availableStock == 0
                                ? "لا يوجد مخزون متاح"
                                : (availableStock == 1
                                    ? "يتوفر عنصر واحد فقط في المخزون"
                                    : "يتوفر $availableStock عناصر في المخزون")),
                      );
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: canIncrease ? const Color(0xFF78B943) : Colors.grey,
                  shape: BoxShape.circle,
                ),
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
