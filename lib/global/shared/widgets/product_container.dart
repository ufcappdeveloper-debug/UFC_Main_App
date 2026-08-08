import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/currency/currency_riverpod.dart';
import 'package:ufc_mobile/riverpod/state.dart';
import 'package:ufc_mobile/screens/feed_old/authentication/pages/signin_page.dart';
import 'package:ufc_mobile/screens/feed_old/categories/widgets/signin_alert_sheet_for_guest_users.dart';
import 'package:ufc_mobile/screens/feed_old/product/pages/product_details_page.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/functions.dart';
import 'package:ufc_mobile/global/shared/functions/product.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/shared/widgets/product_carousel_indicator.dart';
import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';
import 'package:ufc_mobile/global/util/image_network_extension_method.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';

class ProductContainer extends ConsumerStatefulWidget {
  const ProductContainer({
    super.key,
    this.margin,
    this.canBuy = true,
    required this.productData,
    this.showFavoriteIcon = false,
  });
  final bool canBuy;
  final EdgeInsets? margin;
  final bool showFavoriteIcon;
  final ProductModel productData;

  @override
  ConsumerState<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends ConsumerState<ProductContainer> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currencyData = ref.watch(currencyProvider).selectedCurrency;
    final isAuthorized = ref.watch(authProvider.notifier).isAuthorized();
    final currencyRate = ref.watch(currencyProvider).selectedCurrencyRate ?? 1;

    return InkWell(
      onTap: () {
        if (widget.productData.id == null) {
          CustomSnackBar.error(
              context, "We couldn't find the product. Please try again.");
          return;
        }

        final contentId = widget.productData.id?.toString();
        if (contentId != null && contentId.isNotEmpty) {
          AdjustTracker.trackContentView(contentId);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
                canBuy: widget.canBuy, productId: widget.productData.id!),
          ),
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: LayoutBuilder(builder: (context, constraints) {
        // Ensure the width is finite and calculate height based on aspect ratio
        double width =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 393.0;
        double containerWidth = width * 0.43;

        return SizedBox(
            width: containerWidth,
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Container(
                    margin: widget.margin,
                    padding: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 20,
                              offset: Offset(0, 4),
                              color: Color.fromRGBO(0, 0, 0, 0.06))
                        ]),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 12),
                            CarouselSlider(
                              options: CarouselOptions(
                                  height: 102,
                                  viewportFraction: 1,
                                  enableInfiniteScroll: canProductImageScroll,
                                  onPageChanged: (index, reason) =>
                                      setState(() => selectedIndex = index)),
                              items: !isProductImageExist
                                  ? [
                                      SvgPicture.asset(
                                          'assets/images/global/White-Bg-No-Image-Placeholder.svg',
                                          fit: BoxFit.contain),
                                    ]
                                  : widget.productData.images?.map(
                                      (i) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 102,
                                              width: size(context).width,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: (i.location == null ||
                                                        i.location!.isEmpty)
                                                    ? SvgPicture.asset(
                                                        'assets/images/global/No-Image-Placeholder.svg',
                                                        fit: BoxFit.contain)
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            i.location ?? "",
                                                        placeholder:
                                                            loadingPlaceholder,
                                                        errorWidget:
                                                            errorWidget,
                                                        fit: BoxFit.contain,
                                                      ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ).toList(),
                            ),
                            widget.productData.images?.isNotEmpty == true &&
                                    widget.productData.images!.length > 1
                                ? ProductCarouselIndicator(
                                    selectedIndex: selectedIndex,
                                    carouselLength:
                                        widget.productData.images!.length,
                                  )
                                : const SizedBox.shrink(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //* Product Ratings section
                                  if (widget.productData.rating != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Color(0xffF8E71C),
                                        ),
                                        const SizedBox(width: 2.5),
                                        CustomText(
                                          text: widget.productData.rating
                                                  ?.toStringAsFixed(1) ??
                                              "0.0",
                                          fontSize: 10,
                                          color: const Color(0xff8E8E93),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: ProductUtils.productName(
                                                  widget.productData),
                                              maxLines: 1,
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.clip,
                                            ),
                                            SizedBox(
                                              width: 73,
                                              child: CustomText(
                                                text: ProductUtils
                                                    .productDescription(
                                                        widget.productData)??'',
                                                maxLines: 2,
                                                fontSize: 10,
                                                fontFamily: 'Poppins',
                                                overflow: TextOverflow.clip,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff9C9CA0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Kanit",
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: (widget.productData
                                                                    .variants ==
                                                                null ||
                                                            widget
                                                                .productData
                                                                .variants!
                                                                .isEmpty
                                                        ? 0.00
                                                        : ((widget
                                                                    .productData
                                                                    .variants!
                                                                    .first
                                                                    .price ??
                                                                0.00) *
                                                            currencyRate))
                                                    .toStringAsFixed(2)),
                                            countryCodeTextSpan(currencyData),
                                            if (isDiscountPriceExist(
                                                widget.productData))
                                              TextSpan(
                                                text:
                                                    "\n${((widget.productData.variants?.first.originalPrice ?? 0.0) * currencyRate).toStringAsFixed(1)}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Kanit",
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                            if (isDiscountPriceExist(
                                                widget.productData))
                                              countryCodeTextSpan(currencyData,
                                                  isOffer: true),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Expanded(child:
                            IgnorePointer(
                              ignoring: !isSockAvailable,
                              child: InkWell(
                                  onTap: !widget.canBuy
                                      ? () => CustomSnackBar.error(context,
                                          "Purchase available only at preferred shop")
                                      : isSockAvailable
                                          ? () async {
                                              if (!isAuthorized) {
                                                showUnauthorizedBottomSheet(
                                                  context,
                                                  onSignInPressed: () {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SignInPage()),
                                                      (route) => false,
                                                    );
                                                  },
                                                );
                                                return;
                                              }

                                              if (widget.productData.variants ==
                                                      null ||
                                                  widget.productData.variants!
                                                      .isEmpty) {
                                                CustomSnackBar.error(context,
                                                    "Something went wrong, please contact admin");
                                                return;
                                              }

                                              final variant = widget
                                                  .productData.variants!.first;
                                              final stock = variant.stock ?? 0;

                                              final existingItem = ref
                                                  .read(cartProvider)
                                                  .cartItems
                                                  .firstWhere(
                                                    (item) =>
                                                        item.variant?.id ==
                                                        variant.id,
                                                    orElse: () => CartItemModel(
                                                        quantity: 0),
                                                  );

                                              final currentQuantity =
                                                  existingItem.quantity ?? 0;

                                              if (currentQuantity >= stock) {
                                                CustomSnackBar.error(context,
                                                    "Cannot add more. Stock limit reached.");
                                                return;
                                              }
                                              final Map<String, dynamic> data =
                                                  {
                                                "quantity": 1,
                                                "variant_id": widget.productData
                                                    .variants?.first.id,
                                                "product_id":
                                                    widget.productData.id,
                                              };
                                              try {
                                                final future = ref
                                                    .read(cartProvider)
                                                    .addToCart(data);

                                                final result =
                                                    await LoadingDialog.show(
                                                        context, future);

                                                if (mounted && (result)) {
                                                  if (!context.mounted) return;
                                                  CustomSnackBar.success(
                                                      context,
                                                      "Item added to cart successfully");
                                                  ref
                                                      .read(cartProvider)
                                                      .getCartItems();
                                                }
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                CustomSnackBar.error(context,
                                                    'Oops, something went wrong!');
                                              }
                                            }
                                          : () {
                                              CustomSnackBar.error(context,
                                                  "Product Out of Stock");
                                            },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                      height: 24,
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 22.5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color:
                                            (!widget.canBuy || !isSockAvailable)
                                                ? Colors.grey
                                                : primaryColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                              text: isSockAvailable
                                                  ? 'ADD TO CART'
                                                  : "OUT OF STOCK",
                                              fontSize: 10,
                                              color: Colors.white),
                                          Image.asset(
                                              'assets/images/navigation/cart.png',
                                              color: Colors.white,
                                              height: 13.5)
                                        ],
                                      ))),
                            ),
                          ],
                        ),
                        if (widget.showFavoriteIcon)
                          const Positioned(
                            top: 6,
                            right: 7,
                            child: Icon(
                              Icons.favorite,
                              color: primaryColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isDiscountPriceExist(widget.productData))
                    Positioned(
                      top: 8,
                      right: 20,
                      child: Container(
                        height: 33,
                        width: 35,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: carminePink),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 11,
                              fontFamily: "Kanit",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: getDiscountPercentage(
                                    ((widget.productData.variants?.first
                                                .price ??
                                            0.0) *
                                        currencyRate),
                                    ((widget.productData.variants?.first
                                                .originalPrice ??
                                            0.0) *
                                        currencyRate)),
                                // style: const TextStyle(fontSize: 7),
                              ),
                              TextSpan(
                                text: "%",
                                style: const TextStyle(fontSize: 7),
                              ),
                              TextSpan(
                                text: "\n${'off'.tr()}".tr(),
                                style: const TextStyle(fontSize: 7),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ));
      }),
    );
  }

  bool get isProductImageExist {
    if (widget.productData.images == null ||
        widget.productData.images!.isEmpty) {
      return false;
    }
    return true;
  }

  bool get canProductImageScroll {
    if (widget.productData.images == null ||
        widget.productData.images!.isEmpty) {
      return false;
    }
    if (widget.productData.images!.length <= 1) return false;
    return true;
  }

  // To verify product availability in stock
  bool get isSockAvailable {
    if (widget.productData.variants == null ||
        widget.productData.variants!.isEmpty) {
      return false;
    }
    return widget.productData.variants!.first.stock != null &&
        widget.productData.variants!.first.stock! > 0;
  }

  InlineSpan countryCodeTextSpan(Currency? currencyData,
          {bool isOffer = false}) =>
      // TextSpan(
      //     text: currencyData?.code ?? "SAR",
      //     style: TextStyle(
      //         color: Colors.black,
      //         fontFamily: 'Poppins',
      //         fontSize: isOffer ? 8 : 10,
      //         fontWeight: isOffer ? FontWeight.w300 : null,
      //         decoration: isOffer ? TextDecoration.lineThrough : null));
      currencyData?.code == "SAR"
          ? WidgetSpan(
              child: SaudiRiyalIcon(
                size: isOffer ? 8 : 10,
                color: Colors.black,
              ),
            )
          : TextSpan(
              text: currencyData?.code ?? "SAR",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: isOffer ? 8 : 10,
                fontWeight: isOffer ? FontWeight.w300 : null,
                decoration: isOffer ? TextDecoration.lineThrough : null,
              ),
            );
}
