import 'dart:ui' as ui;

import 'package:animated_digit/animated_digit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/cart/feed_cart_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/pages/feed_checkout_page_V2.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class CheckoutSection extends StatelessWidget {
  final List<FeedCartItemModel> cartItems;
  final String formattedAmount;

  const CheckoutSection({
    super.key,
    required this.cartItems,
    required this.formattedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            offset: const Offset(0, -1),
            blurRadius: 2.5,
            spreadRadius: 0.6,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          for (final item in cartItems) {
            final qty = item.quantity ?? 0;
            final stock = item.variant?.stock ?? 0;

            if (qty > stock) {
              final productName = isEnglish
                  ? (item.variant?.product?.nameEn ?? "this item")
                  : (item.variant?.product?.nameAr ?? "هذا المنتج");

              String stockMessage;

              if (isEnglish) {
                stockMessage =
                    "Only $stock item${stock == 1 ? '' : 's'} available in stock for $productName";
              } else {
                stockMessage = stock == 0
                    ? "لا يوجد مخزون متاح لـ $productName"
                    : stock == 1
                        ? "يتوفر عنصر واحد فقط في المخزون لـ $productName"
                        : "يتوفر $stock عناصر في المخزون لـ $productName";
              }

              CustomSnackBar.error(context, stockMessage);
              return;
            }
          }
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => FeedCheckoutPageV2(
                cartItems: cartItems,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          height: 56,
          decoration: BoxDecoration(
            color: PetVeterinaryColors.yellowBackground,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🟡 Left side — Cart count + total price
              Row(
                children: [
                  // 🧮 Product count badge
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      int count = 0;
                      if (state is CartLoaded) {
                        count = state.cartCount;
                      }
                      return Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CustomText(
                          text: "$count",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 16),

                  // 💰 Price + SAR
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: AnimatedDigitWidget(
                          value: double.tryParse(formattedAmount) ?? 0,
                          enableSeparator: true,
                          fractionDigits: 2,
                          textStyle: const TextStyle(
                            height: 1,
                            fontSize: 15,
                            fontFamily: AppFontsFamily.english,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      const SaudiRiyalIcon(size: 16, color: Colors.black),
                    ],
                  ),
                ],
              ),

              // 🟢 Right side — Checkout button
              Row(
                children: [
                  CustomText(
                    text: "Checkout".tr(),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
