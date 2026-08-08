import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/riverpod/currency/currency_riverpod.dart';
import 'package:ufc_mobile/screens/feed_old/cart/widgets/cart/cart_item_counter.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/widgets/reusable_reward_price_text.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/functions.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_image.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';

class CartPageProductContainer extends ConsumerStatefulWidget {
  const CartPageProductContainer({
    super.key,
    this.unclaim,
    required this.item,
    required this.onDelete,
    required this.isFavorite,
    required this.onFavorite,
    required this.onDecrement,
    required this.onIncrement,
  });
  final bool isFavorite;
  final CartItemModel item;
  final Future<void> Function()? unclaim;
  final Future<void> Function()? onDelete;
  final Future<void> Function()? onFavorite;
  final Future<void> Function()? onDecrement;
  final Future<void> Function()? onIncrement;

  @override
  ConsumerState<CartPageProductContainer> createState() =>
      _CartPageProductContainerState();
}

class _CartPageProductContainerState
    extends ConsumerState<CartPageProductContainer> {
  bool isLoading = false;
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final currencyData = ref.watch(currencyProvider).selectedCurrency;
    final currencyRate = ref.watch(currencyProvider).selectedCurrencyRate ?? 1;
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            offset: Offset(0, 4),
            color: Color(0xFFE4E4E4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomImage(
                      imageUrl: product?.images?[0].location,
                      height: 94,
                      fit: BoxFit.cover,
                      noImagePlaceholderWidget: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withValues(alpha: 0.11),
                        ),
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CustomText(
                                          text: ProductUtils.productName(
                                            product,
                                          ),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                        if (widget.item.variant
                                                    ?.originalPrice !=
                                                null &&
                                            widget.item.variant!
                                                    .originalPrice !=
                                                0 &&
                                            !widget.item.isClaimed)
                                          Container(
                                            width: 45,
                                            height: 16,
                                            margin: const EdgeInsetsDirectional
                                                .only(start: 5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffFF5732),
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child: CustomText(
                                              text:
                                                  '${getDiscountPercentage(((widget.item.variant?.price ?? 0.0) * currencyRate), ((widget.item.variant?.originalPrice ?? 0.0) * currencyRate))}% ${"Off".tr()}',
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ],
                                    ),
                                    CustomText(
                                      text: ProductUtils.productDescription(
                                        product,
                                      )??'',
                                      maxLines: 2,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.clip,
                                      color: const Color(0xff9C9CA0),
                                    ),
                                    const SizedBox(height: 5),
                                    if (!widget.item.isClaimed)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          CustomText(
                                            text: ((widget.item.variant
                                                            ?.price ??
                                                        0.00) *
                                                    currencyRate)
                                                .toStringAsFixed(2), //'540',
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            textAlign: TextAlign.end,
                                          ),
                                          // CustomText(
                                          //   text:
                                          //       " ${currencyData?.code ?? 'SAR'}",
                                          //   fontFamily: 'Poppins',
                                          //   fontSize: 10,
                                          //   textAlign: TextAlign.end,
                                          // ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                if (currencyData?.code == "SAR")
                                                  WidgetSpan(
                                                    child: SaudiRiyalIcon(
                                                      size: 10,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                else
                                                  TextSpan(
                                                    text: currencyData?.code ??
                                                        'SAR',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),

                                          if (widget.item.variant
                                                  ?.originalPrice !=
                                              null)
                                            kWidth5,
                                          if (widget.item.variant
                                                      ?.originalPrice !=
                                                  null &&
                                              widget.item.variant!
                                                      .originalPrice !=
                                                  0)
                                            CustomText(
                                                text: ((widget.item.variant
                                                                ?.originalPrice ??
                                                            0.00) *
                                                        currencyRate)
                                                    .toStringAsFixed(2),
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                textAlign: TextAlign.end,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          if (widget.item.variant
                                                      ?.originalPrice !=
                                                  null &&
                                              widget.item.variant!
                                                      .originalPrice !=
                                                  0)
                                            // CustomText(
                                            //     text:
                                            //         " ${currencyData?.code ?? 'SAR'}",
                                            //     fontSize: 8,
                                            //     fontFamily: 'Poppins',
                                            //     textAlign: TextAlign.end,
                                            //     fontWeight: FontWeight.w300,
                                            //     decoration:
                                            //         TextDecoration.lineThrough),
                                            if (currencyData?.code == "SAR")
                                              const SaudiRiyalIcon(size: 8)
                                            else
                                              CustomText(
                                                text:
                                                    " ${currencyData?.code ?? 'SAR'}",
                                                fontSize: 8,
                                                fontFamily: 'Poppins',
                                                textAlign: TextAlign.end,
                                                fontWeight: FontWeight.w300,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              if (!widget.item.isClaimed)
                                CartItemCounter(
                                  isLoading: isUpdating,
                                  quantity: widget.item.quantity ?? 0,
                                  onDecrement: isUpdating
                                      ? null
                                      : () async {
                                          try {
                                            safeSetState(
                                                this, () => isUpdating = true);
                                            if (widget.onDecrement != null) {
                                              await widget.onDecrement!();
                                            }
                                          } finally {
                                            safeSetState(
                                                this, () => isUpdating = false);
                                          }
                                        },
                                  onIncrement: isUpdating
                                      ? null
                                      : () async {
                                          try {
                                            safeSetState(
                                                this, () => isUpdating = true);
                                            if (widget.onIncrement != null) {
                                              await widget.onIncrement!();
                                            }
                                          } finally {
                                            safeSetState(
                                                this, () => isUpdating = false);
                                          }
                                        },
                                ),
                              if (widget.item.isClaimed)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .grey.shade200, // Light grey background
                                    borderRadius: BorderRadius.circular(
                                        4), // Smaller corner radius
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 0.8), // Thinner border
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'x',
                                        style: TextStyle(
                                          fontSize: 12, // Smaller font size
                                          fontWeight: FontWeight
                                              .w500, // Slightly lighter weight
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 2), // Reduced spacing
                                      Text(
                                        '${widget.item.quantity}',
                                        style: TextStyle(
                                          fontSize: 12, // Smaller font size
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (widget.item.isClaimed)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.5),
                                child: ReusableRewardPriceText(
                                  originalPrice: '0',
                                  discountedPrice:
                                      (((widget.item.variant?.price ?? 0.00) *
                                                  (widget.item.quantity ?? 0)) *
                                              currencyRate)
                                          .toStringAsFixed(2),
                                  isInCartList: true,
                                  isBig: false,
                                ),
                              ),
                            if (!widget.item.isClaimed)
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      safeSetState(
                                          this, () => isLoading = true);
                                      if (widget.onFavorite != null) {
                                        await widget.onFavorite!();
                                      }
                                    } finally {
                                      safeSetState(
                                          this, () => isLoading = false);
                                    }
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(
                                    children: [
                                      CustomText(
                                          text: widget.isFavorite
                                              ? "Remove"
                                              : "Add to Favorite",
                                          fontSize: 10,
                                          color: primaryColor),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Icon(
                                            widget.isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border_rounded,
                                            size: 15,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(
                                height: 18,
                                child: VerticalDivider(
                                    thickness: 1.25, color: Color(0xffE4E4E4))),
                            Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      safeSetState(
                                          this, () => isLoading = true);
                                      if (!widget.item.isClaimed) {
                                        if (widget.onDelete != null) {
                                          await widget.onDelete!();
                                        }
                                      } else {
                                        if (widget.unclaim != null) {
                                          await widget.unclaim!();
                                        }
                                      }
                                    } finally {
                                      safeSetState(
                                          this, () => isLoading = false);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                          text: (!widget.item.isClaimed)
                                              ? 'Delete'
                                              : 'Unclaim',
                                          fontSize: 10,
                                          color: const Color(0xFFEE5A5A)),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        child: (!widget.item.isClaimed)
                                            ? Image.asset(
                                                "assets/images/cart/delete.png",
                                                height: 13)
                                            : const Icon(
                                                Icons.backspace_outlined,
                                                size: 15,
                                                color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withValues(alpha: 0.11),
              ),
              child: LoadingAnimationWidget.twoRotatingArc(
                size: 33,
                color: primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  ProductModel? get product => widget.item.variant?.product;
}
