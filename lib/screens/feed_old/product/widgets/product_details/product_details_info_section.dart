import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/currency/currency_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/product/widgets/custom_qty_container.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/functions.dart';
import 'package:ufc_mobile/global/shared/functions/product.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class ProductDetailsInfoSection extends ConsumerStatefulWidget {
  const ProductDetailsInfoSection({
    super.key,
    required this.canBuy,
    required this.product,
    required this.qtyController,
    required this.isLoyaltyProduct,
  });
  final bool canBuy;
  final ProductModel product;
  final bool isLoyaltyProduct;
  final TextEditingController qtyController;

  @override
  ConsumerState<ProductDetailsInfoSection> createState() =>
      _ProductDetailsInfoSectionState();
}

class _ProductDetailsInfoSectionState
    extends ConsumerState<ProductDetailsInfoSection> {
  int vatPercentage = 0;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authProvider).value;
    vatPercentage = (user?.vatPercentage ?? 0).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final currencyData = ref.watch(currencyProvider).selectedCurrency;
    final currencyRate = ref.watch(currencyProvider).selectedCurrencyRate ?? 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              CustomText(
                  text: (isEnglish
                          ? widget.product.nameEn
                          : isArabic
                              ? widget.product.nameAr
                              : widget.product.nameUr) ??
                      "",
                  fontSize: 18,
                  // fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500),
              const Spacer(),
              widget.isLoyaltyProduct || widget.product.rating == null
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: Color(0xffF8E71C)),
                        const SizedBox(width: 5),
                        CustomText(
                            text: (widget.product.rating ?? 0.0)
                                .toStringAsFixed(1),
                            fontSize: 12,
                            color: const Color(0xff8E8E93)),
                      ],
                    ),
            ],
          ),
        ),
        if (!isDiscountPriceExist(widget.product))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                            text: (widget.product.variants == null ||
                                        widget.product.variants!.isEmpty
                                    ? 0.00
                                    : ((widget.product.variants?.first.price ??
                                            0.00) *
                                        currencyRate))
                                .toStringAsFixed(2),
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 5, right: 5),
                          child:
                              //  CustomText(
                              //   text: currencyData?.code ?? 'SAR',
                              //   fontSize: 12,
                              //   textAlign: TextAlign.end,
                              //   fontWeight: FontWeight.w300,
                              // ),
                              (currencyData?.code == "SAR")
                                  ? SaudiRiyalIcon(
                                      size: 12, color: Colors.black)
                                  : CustomText(
                                      text: currencyData?.code ?? 'SAR',
                                      fontSize: 12,
                                      textAlign: TextAlign.end,
                                      fontWeight: FontWeight.w300,
                                    ),
                        ),
                      ],
                    ),
                    if (vatPercentage > 0)
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: CustomText(
                          text: "(${"Exclusive VAT".tr()} $vatPercentage%)",
                          height: 0.7,
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: const Color(
                            0xFFC7C7C7,
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                widget.isLoyaltyProduct || !widget.canBuy
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          CustomText(
                              text: 'Qty'.tr(),
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                          const SizedBox(width: 5),
                          CustomQtyContainer(
                            controller: widget.qtyController,
                            productData: widget.product,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        if (isDiscountPriceExist(widget.product))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                              text: ((widget.product.variants?.first.price ??
                                          0.0) *
                                      currencyRate)
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                fontFamily: "Kanit",
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              )),
                          // TextSpan(
                          //   text: currencyData?.code ?? 'SAR',
                          //   style: const TextStyle(
                          //     fontSize: 10,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          currencyData?.code == 'SAR'
                              ? WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: SaudiRiyalIcon(
                                    size: 10,
                                  ),
                                )
                              : TextSpan(
                                  text: currencyData?.code ?? '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                  text: ((widget.product.variants?.first
                                                  .originalPrice ??
                                              0.0) *
                                          currencyRate)
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontFamily: "Kanit",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough)),
                              // TextSpan(
                              //   text: currencyData?.code ?? 'SAR',
                              //   style: const TextStyle(
                              //     fontSize: 8,
                              //     fontWeight: FontWeight.w300,
                              //     decoration: TextDecoration.lineThrough,
                              //   ),
                              // ),

                              (currencyData?.code == "SAR")
                                  ? TextSpan(
                                      children: [
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: SaudiRiyalIcon(size: 8),
                                        )
                                      ],
                                    )
                                  : TextSpan(
                                      text: currencyData?.code ?? 'SAR',
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w300,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 16,
                          width: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xffFF5732),
                              borderRadius: BorderRadius.circular(3)),
                          child: CustomText(
                            text:
                                '${getDiscountPercentage(((widget.product.variants?.first.price ?? 0.0) * currencyRate), ((widget.product.variants?.first.originalPrice ?? 0.0) * currencyRate))}% ${"Off".tr()}',
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                !widget.canBuy
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          CustomText(
                              text: 'Qty'.tr(),
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                          const SizedBox(width: 5),
                          CustomQtyContainer(
                            controller: widget.qtyController,
                            productData: widget.product,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        kHeight20,
        if (widget.canBuy)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            height: 87,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0xffe5e5e5),
                    offset: Offset(0, 16),
                    blurRadius: 16)
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('assets/images/product/shopping_cart.png',
                            height: 18),
                        const SizedBox(width: 15),
                        CustomText(text: 'Stock'.tr()),
                      ],
                    ),
                    const Spacer(),
                    CustomText(
                        text: (widget.product.variants == null ||
                                    widget.product.variants!.isEmpty ||
                                    widget.product.variants!.first.stock!
                                        .isNegative
                                ? 0
                                : widget.product.variants?.first.stock ?? 0)
                            .toString()),
                    const SizedBox(width: 20),
                  ],
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('assets/images/product/check.png',
                            height: 17),
                        const SizedBox(width: 16),
                        CustomText(
                          text: 'Product Sold'.tr(),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomText(
                        text: (widget.product.variants == null ||
                                    widget.product.variants!.isEmpty
                                ? 0
                                : widget.product.variants?.first.sold ?? 0)
                            .toString()),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
