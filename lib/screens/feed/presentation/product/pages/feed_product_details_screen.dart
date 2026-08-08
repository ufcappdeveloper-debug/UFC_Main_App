import 'dart:ui' as ui;

import 'package:animated_digit/animated_digit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/widgets.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_indicator.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_divider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/screen_width_utils.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_variant_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/pages/feed_checkout_page_V2.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/pro/no_stock_card.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/review_list.dart';

import '../../../../../global/extensions/saudi_riyal_icon.dart';
import '../../../../../global/shared/constants/constants.dart';
import '../../../../../global/shared/functions/is_network_error.dart';
import '../../../../../global/shared/widgets/app_image_place_holder.dart';
import '../../../../../global/shared/widgets/custom_widgets/no_internet.dart';
import '../../../../../global/util/common/common_utils.dart';
import '../../../application/cart/cart_cubit.dart';
import '../../../application/cart/cart_state.dart';
import '../../../application/productList/product_list_cubit.dart';
import '../../../application/productList/product_list_state.dart';
import '../../../application/product_rating/rating_cubit.dart';
import '../../../application/product_rating/rating_state.dart';
import '../../../domain/entities/cart/feed_add_cart_params_model.dart';
import '../widgets/add_review.dart';
import '../widgets/quantity_selector.dart';

class FeedProductDetailsScreen extends StatefulWidget {
  const FeedProductDetailsScreen(
      {super.key,
      required this.productId,
      this.canBuy = false,
      this.isLoyaltyProduct = false,
      this.onLoyalityProductClaimPressed,
      this.isOutOfStock = false});

  final int productId;
  final bool isOutOfStock;
  final bool canBuy;
  final bool isLoyaltyProduct;
  final VoidCallback? onLoyalityProductClaimPressed;

  @override
  State<FeedProductDetailsScreen> createState() =>
      _FeedProductDetailsScreenState();
}

class _FeedProductDetailsScreenState extends State<FeedProductDetailsScreen>
    with ScreenEngagementTracker {
  ProductVariantModel? selectedVariant;

  int counter = 1;
  int cartCount = 0;
  bool isLoading = false;

  bool get isEnglish =>
      Localizations.localeOf(context).languageCode.toLowerCase() == "en";
  ProductModel? productItem;

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    final userId = authCubit.currentUser?.id;
    context
        .read<ProductListCubit>()
        .getProductById(widget.productId, userId ?? 0);
    if (userId != null) {
      context.read<CartCubit>().fetchCartCount();
    }
    context
        .read<ProductRatingCubit>()
        .fetchRatings(productId: widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = ScreenWidthUtils.isWide(context);
    final isWideLess = ScreenWidthUtils.isWideLess(context);
    final isWideMore = ScreenWidthUtils.isWideMore(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();

        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Image.asset(
                    AppPngImages.sharePngIcon,
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                  onPressed: () {
                    final productId = productItem?.id ?? '';
                    final productName = ProductUtils.productName(productItem);
                    final playStoreLink =
                        'https://play.google.com/store/apps/details?id=sa.com.ufc.mobile&productId=$productId';
                    Share.share(playStoreLink, subject: productName);
                  },
                ),
              ],
            ),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<ProductRatingCubit, ProductRatingState>(
              listener: (context, state) {
                if (state is ProductRatingSubmitSuccess) {
                  Navigator.of(context).pop();
                  context
                      .read<ProductRatingCubit>()
                      .fetchRatings(productId: widget.productId);
                  CustomSnackBar.success(
                    context,
                    isEnglish
                        ? "Review submitted successfully!"
                        : "تم ارسال التقييم بنجاح!",
                  );
                } else if (state is ProductRatingSubmitError) {
                  context
                      .read<ProductRatingCubit>()
                      .fetchRatings(productId: widget.productId);
                  CustomSnackBar.error(context, state.message);
                }
              },
            ),
            BlocListener<CartCubit, CartState>(
              listener: (context, state) {
                setState(() {
                  isLoading = state is CartLoading;
                });

                if (state is CartAdded) {
                  CustomSnackBar.success(
                      context,
                      isEnglish
                          ? "Added to cart successfully!"
                          : "تمت الإضافة إلى السلة بنجاح");
                }
                if (state is CartCountLoaded) {
                  setState(() => cartCount = state.count);
                }
                if (state is CartError) {
                  CustomSnackBar.error(context, state.message.toString());
                }
              },
            ),
          ],
          child: BlocBuilder<ProductListCubit, ProductListState>(
            builder: (context, state) {
              final authCubit = context.read<AuthCubit>();
              final userId = authCubit.currentUser?.id;
              if (state is ProductListLoading) {
                return const Center(child: CustomIndicator(padding: 50));
              }

              if (state is ProductListError) {
                if (isNetworkError(state.message.toString())) {
                  return NoInternet(
                    type: AppType.feed,
                    onTap: () {
                      if (userId != null) {
                        context
                            .read<ProductListCubit>()
                            .getProductById(widget.productId, userId);
                      }
                    },
                  );
                }
                return CustomReloadProvider(
                    height: 118,
                    onPressed: () {
                      if (userId != null) {
                        context
                            .read<ProductListCubit>()
                            .getProductById(widget.productId, userId);
                      }
                    });
              }

              if (state is ProductListLoaded) {
                ProductModel? data = state.singleProduct;
                productItem = data;
                if (data == null) {
                  return Center(
                    child: CustomReloadProvider(
                      height: 118,
                      onPressed: () {
                        if (userId != null) {
                          context
                              .read<ProductListCubit>()
                              .getProductById(widget.productId, userId);
                        }
                      },
                    ),
                  );
                }

                selectedVariant ??= (data.variants?.isNotEmpty == true)
                    ? data.variants!.first
                    : null;

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: PetVeterinaryColors.backgroundColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ImageWithPlaceHolder(
                              imageUrl: (data.images?.isNotEmpty ?? false)
                                  ? data.images!.first.location
                                  : null,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: 100,
                            ),
                          ),

                          //           final productId = data?.id ?? '';
                          //           final productName =
                          //               ProductUtils.productName(data);

                          //           final playStoreLink =
                          //               'https://play.google.com/store/apps/details?id=sa.com.ufc.mobile&productId=$productId';

                          //           Share.share(playStoreLink,
                          //               subject: productName);

                          const SizedBox(height: 24),

                          /// Title + Price
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: isEnglish
                                          ? (data.nameEn ?? "Product name")
                                          : (data.nameAr ?? "اسم المنتج"),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    BlocConsumer<FavoriteCubit, FavoriteState>(
                                      listener: (context, state) {
                                        if (state is FavoriteActionSuccess &&
                                            state.productId == data?.id) {
                                          final updatedData = data?.copyWith(
                                              isFavorite:
                                                  !(data?.isFavorite ?? false));
                                          final message = (updatedData
                                                      ?.isFavorite ??
                                                  false)
                                              ? "Favorite added successfully"
                                              : "Favorite removed successfully";
                                          data = updatedData;
                                          CustomSnackBar.success(
                                              context, message);
                                        } else if (state is FavoriteError) {
                                          CustomSnackBar.error(context,
                                              state.message.toString());
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading =
                                            state is FavoriteLoading;

                                        return isLoading
                                            ? SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(primaryColor),
                                                ),
                                              )
                                            : ProductUtils.favoriteButton(
                                                product: data,
                                                onTap: () async {
                                                  final isGuest = context
                                                      .read<AuthCubit>()
                                                      .isGuest;

                                                  if (isGuest) {
                                                    CustomSnackBar.error(
                                                        context,
                                                        "Please login to continue");
                                                    return;
                                                  }

                                                  await context
                                                      .read<FavoriteCubit>()
                                                      .addOrRemoveFavProduct(
                                                          data?.id ?? 0);
                                                },
                                              );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // First row: original price + discount %
                                    if ((selectedVariant?.originalPrice ?? 0) >
                                        (selectedVariant?.price ?? 0))
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: PetVeterinaryColors
                                                  .yellowBackground, // yellow background
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: CustomText(
                                              text:
                                                  "${(((selectedVariant!.originalPrice! - selectedVariant!.price!) / selectedVariant!.originalPrice!) * 100).round()}%",
                                              fontSize: 9,
                                            ),
                                          ),

                                          const SizedBox(width: 6),
                                          SaudiRiyalIcon(
                                            size: 14,
                                            color: PetVeterinaryColors
                                                .newPetLightGray,
                                          ),

                                          CustomText(
                                            text: selectedVariant?.originalPrice
                                                    ?.toStringAsFixed(2) ??
                                                "",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15,
                                            color: PetVeterinaryColors
                                                .newPetLightGray,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),

                                          // Percentage badge
                                        ],
                                      ),

                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        SaudiRiyalIcon(
                                            size: 14, color: Colors.black),
                                        CustomText(
                                          text: selectedVariant?.price
                                                  ?.toStringAsFixed(2) ??
                                              "0.00",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          // const Divider(thickness: 0.1, color: Colors.grey),
                          const CustomDivider(
                              horizontalPadding: 16,
                              thickness: 0.25,
                              color: PetVeterinaryColors.newPetLightGray),
                          SizedBox(
                            height: 14,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomText(
                              text: "Select number of bags",
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),

                          /// Quantity
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: BlocBuilder<CartCubit, CartState>(
                              builder: (context, state) {
                                final variantStock =
                                    (selectedVariant?.stock ?? 0);
                                final existingQty = context
                                    .read<CartCubit>()
                                    .getExistingQuantityForVariant(
                                        selectedVariant?.id);

                                final rawRemaining = variantStock - existingQty;

                                final remainingStock = rawRemaining <= 0
                                    ? 0
                                    : rawRemaining.clamp(0, variantStock);

                                return QuantitySelector(
                                  isWide: isWide,
                                  stock: remainingStock,
                                  initialQuantity: counter,
                                  onSelected: (qty) =>
                                      setState(() => counter = qty),
                                );
                              },
                            ),
                          ),

                          const CustomDivider(
                              horizontalPadding: 16,
                              thickness: 0.25,
                              color: PetVeterinaryColors.newPetLightGray),

                          BlocBuilder<CartCubit, CartState>(
                            builder: (context, state) {
                              final remainingStock =
                                  (selectedVariant?.stock ?? 0) -
                                      context
                                          .read<CartCubit>()
                                          .getExistingQuantityForVariant(
                                              selectedVariant?.id);

                              return Column(
                                children: [
                                  if (widget.isOutOfStock ||
                                      remainingStock <= 0 ||
                                      counter == 0)
                                    const NoStockContainer(),
                                  SizedBox(
                                      height: (widget.isOutOfStock ||
                                              remainingStock <= 0)
                                          ? 8
                                          : 16),
                                ],
                              );
                            },
                          ),

                          /// Description
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CustomText(
                                text: "Description",
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: CustomText(
                                text: ProductUtils.productDescription(data) ??
                                    (isEnglish ? "Not specified" : "غير محدد"),
                                fontSize: 15,
                                color: PetVeterinaryColors.newPetDarkGray),
                          ),

                          const CustomDivider(
                              horizontalPadding: 16,
                              thickness: 0.25,
                              color: PetVeterinaryColors.newPetLightGray),

                          /// Reviews Section
                          BlocBuilder<ProductRatingCubit, ProductRatingState>(
                            builder: (context, state) {
                              List<Widget> reviewWidgets = [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 16),
                                  child: CustomText(
                                    text: "Reviews",
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ];

                              if (state is ProductRatingLoading) {
                                reviewWidgets.add(const Center(
                                    child: CustomIndicator(padding: 20)));
                              } else if (state is ProductRatingLoaded) {
                                if (state.ratings.isEmpty) {
                                  reviewWidgets.add(
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 50),
                                      alignment: Alignment.center,
                                      child: CustomText(
                                          text: "No reviews yet.",
                                          fontFamily: isEnglish
                                              ? AppFontsFamily.english
                                              : AppFontsFamily.arabic,
                                          fontSize: 15,
                                          color: Colors.black54),
                                    ),
                                  );
                                } else {
                                  reviewWidgets.add(Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsetsGeometry.symmetric(
                                              horizontal: 16),
                                          child: ReviewList(
                                              isFromProduct: true,
                                              reviews: state.ratings)),
                                      kHeight15,
                                    ],
                                  ));
                                }
                              } else if (state is ProductRatingError) {
                                reviewWidgets.add(
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(state.message,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ),
                                );
                              }

                              // Add Review Button
                              reviewWidgets.add(Column(children: [
                                const CustomDivider(
                                    horizontalPadding: 16,
                                    thickness: 0.25,
                                    color: PetVeterinaryColors.newPetLightGray),
                                SizedBox(height: 18),
                              ]));

                              reviewWidgets.add(
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: GestureDetector(
                                    onTap: () {
                                      showBtmSheet(
                                          context,
                                          AddReviewDialog(
                                            productId: widget.productId,
                                            isEnglish: isEnglish,
                                            onSubmit: (rating, review) {
                                              context
                                                  .read<ProductRatingCubit>()
                                                  .submitRating(
                                                    productId: widget.productId,
                                                    rating: rating,
                                                    review: review,
                                                  );
                                            },
                                          ));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      decoration: BoxDecoration(
                                        boxShadow: [customBoxShadow],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/svg/feed/star.svg',
                                                  height: 20,
                                                  width: 20,
                                                ),
                                                SizedBox(width: 8),
                                                CustomText(
                                                    text: "Add a review",
                                                    fontSize: isWide ? 15 : 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                            const Icon(
                                              Icons.add_circle_outline,
                                              color: PetVeterinaryColors
                                                  .mainColorUFC,
                                              size: 20,
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              );

                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: reviewWidgets);
                            },
                          ),
                          const SizedBox(
                              height: 80), // Extra spacing for bottom bar
                        ],
                      ),
                    ),
                    BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                      final remainingStock = (selectedVariant?.stock ?? 0) -
                          context
                              .read<CartCubit>()
                              .getExistingQuantityForVariant(
                                  selectedVariant?.id);

                      if (!widget.isOutOfStock &&
                          (remainingStock > 0) &&
                          !(counter == 0)) {
                        /// Bottom bar
                        return Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
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
                              child: Column(
                                children: [
                                  kHeight10,
                                  Directionality(
                                      textDirection: ui.TextDirection.ltr,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// 🟡 Cart Button
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: isLoading
                                                  ? null
                                                  : () async {
                                                      final isGuest = context
                                                          .read<AuthCubit>()
                                                          .isGuest;

                                                      if (isGuest) {
                                                        CustomSnackBar.error(
                                                            context,
                                                            "Please login to continue");
                                                        return;
                                                      }

                                                      if (selectedVariant ==
                                                          null) return;

                                                      final cartCubit = context
                                                          .read<CartCubit>();

                                                      // Get remaining stock before adding (optional for early check)
                                                      final preRemainingStock =
                                                          (selectedVariant
                                                                      ?.stock ??
                                                                  0) -
                                                              cartCubit
                                                                  .getExistingQuantityForVariant(
                                                                      selectedVariant
                                                                          ?.id);

                                                      if (counter >
                                                          preRemainingStock) {
                                                        CustomSnackBar.error(
                                                          context,
                                                          isEnglish
                                                              ? "Only $preRemainingStock item${preRemainingStock == 1 ? '' : 's'} left in stock"
                                                              : (preRemainingStock ==
                                                                      1
                                                                  ? "يتبقى عنصر واحد فقط في المخزون"
                                                                  : "يتبقى $preRemainingStock عناصر في المخزون"),
                                                        );
                                                        setState(() {
                                                          counter =
                                                              preRemainingStock;
                                                        });
                                                        return;
                                                      }

                                                      // Add to cart
                                                      await cartCubit.addToCart(
                                                        AddToCartParams(
                                                          productId:
                                                              widget.productId,
                                                          variantId:
                                                              selectedVariant!
                                                                      .id ??
                                                                  0,
                                                          quantity: counter,
                                                        ),
                                                        availableStock:
                                                            selectedVariant
                                                                    ?.stock ??
                                                                0,
                                                      );

                                                      // Recalculate remaining stock from updated cart
                                                      final updatedRemainingStock =
                                                          (selectedVariant
                                                                      ?.stock ??
                                                                  0) -
                                                              cartCubit
                                                                  .getExistingQuantityForVariant(
                                                                      selectedVariant
                                                                          ?.id);

                                                      if (counter >
                                                          updatedRemainingStock) {
                                                        setState(() {
                                                          counter =
                                                              updatedRemainingStock;
                                                        });
                                                      }
                                                    },
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    isWideMore
                                                        ? 16
                                                        : isWideLess
                                                            ? 12
                                                            : 10,
                                                    5,
                                                    isWideMore
                                                        ? 16
                                                        : isWideLess
                                                            ? 12
                                                            : 10,
                                                    5),
                                                height: 56,
                                                decoration: BoxDecoration(
                                                  color: PetVeterinaryColors
                                                      .yellowBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: isLoading
                                                    ? const Center(
                                                        child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    : Directionality(
                                                        textDirection:
                                                            Directionality.of(
                                                                context),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            /// Cart text

                                                            Row(children: [
                                                              /// Cart Count
                                                              Container(
                                                                height: 40,
                                                                width: isWide
                                                                    ? 40
                                                                    : 36,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child:
                                                                    CustomText(
                                                                  text:
                                                                      "$counter",
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                width: isWideMore
                                                                    ? 16
                                                                    : isWideLess
                                                                        ? 10
                                                                        : 8,
                                                              ),

                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Directionality(
                                                                    textDirection: ui
                                                                        .TextDirection
                                                                        .ltr,
                                                                    child:
                                                                        AnimatedDigitWidget(
                                                                      value: double.parse(formatNumber((selectedVariant?.price ??
                                                                              0) *
                                                                          counter)),
                                                                      enableSeparator:
                                                                          true,
                                                                      fractionDigits:
                                                                          2,
                                                                      textStyle:
                                                                          TextStyle(
                                                                        height:
                                                                            1,
                                                                        fontSize: isWideMore
                                                                            ? 15
                                                                            : isWideLess
                                                                                ? 14
                                                                                : 13,
                                                                        fontFamily:
                                                                            AppFontsFamily.english,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SaudiRiyalIcon(
                                                                      size: isWideMore
                                                                          ? 15
                                                                          : 13,
                                                                      color: Colors
                                                                          .black),
                                                                ],
                                                              ),
                                                            ]),

                                                            Row(
                                                              children: [
                                                                CustomText(
                                                                  text: counter ==
                                                                          1
                                                                      ? 'Add item'
                                                                          .tr()
                                                                      : 'Add items'
                                                                          .tr(),
                                                                  fontSize:
                                                                      isWideMore
                                                                          ? 12
                                                                          : 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                SizedBox(
                                                                    width: isWideMore
                                                                        ? 6
                                                                        : isWideLess
                                                                            ? 4
                                                                            : 2),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_rounded,
                                                                  size:
                                                                      isWideMore
                                                                          ? 16
                                                                          : 14,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ],
                                                            ),

                                                            /// Price + Currency
                                                          ],
                                                        )),
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                              width: isWideMore
                                                  ? 12
                                                  : isWideLess
                                                      ? 8
                                                      : 4),

                                          /// ➕➖ Counter
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: PetVeterinaryShadows
                                                  .standardLight,
                                            ),
                                            child: Builder(
                                              builder: (context) {
                                                final variantStock =
                                                    (selectedVariant?.stock ??
                                                        0);
                                                final existingQty = context
                                                    .read<CartCubit>()
                                                    .getExistingQuantityForVariant(
                                                        selectedVariant?.id);

                                                final rawRemaining =
                                                    variantStock - existingQty;

                                                final remainingStock =
                                                    rawRemaining <= 0
                                                        ? 0
                                                        : rawRemaining.clamp(
                                                            0, variantStock);

                                                return Row(
                                                  children: [
                                                    /// ➖ Decrease
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (counter > 1) {
                                                          setState(
                                                              () => counter--);
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: counter > 1
                                                              ? const Color(
                                                                  0xFF78B943)
                                                              : Colors.grey,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        width: 24,
                                                        height: 24,
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Icon(
                                                            Icons.remove,
                                                            color: Colors.white,
                                                            size: 16),
                                                      ),
                                                    ),

                                                    /// Counter Text
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: counter > 99
                                                            ? (isWideMore
                                                                ? 20.0
                                                                : isWideLess
                                                                    ? 12
                                                                    : 10.0)
                                                            : (isWideMore
                                                                ? 22.0
                                                                : 14.0),
                                                      ),
                                                      child: CustomText(
                                                        text: "$counter",
                                                        fontSize: 15,
                                                      ),
                                                    ),

                                                    /// ➕ Increase
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (counter <
                                                            remainingStock) {
                                                          setState(
                                                              () => counter++);
                                                        } else {
                                                          CustomSnackBar.error(
                                                            context,
                                                            isEnglish
                                                                ? "Only $remainingStock item${remainingStock == 1 ? '' : 's'} left in stock"
                                                                : (remainingStock ==
                                                                        0
                                                                    ? "لا يوجد مخزون متاح"
                                                                    : (remainingStock ==
                                                                            1
                                                                        ? "يتبقى عنصر واحد فقط في المخزون"
                                                                        : "يتبقى $remainingStock عناصر في المخزون")),
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: counter <
                                                                  remainingStock
                                                              ? const Color(
                                                                  0xFF78B943)
                                                              : Colors.grey,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        width: 24,
                                                        height: 24,
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                            size: 16),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )),
                                  kHeight20,
                                  CustomButton(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: isEnglish
                                          ? AppFontsFamily.english
                                          : AppFontsFamily.arabic,
                                      height: 45,
                                      radius: 22.5,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.9,
                                      textColor: primaryColor,
                                      color: Colors.white,
                                      border: Border.all(color: primaryColor),
                                      title: 'Order Now',
                                      onTap: productItem == null
                                          ? null
                                          : () {
                                              final isGuest = context
                                                  .read<AuthCubit>()
                                                  .isGuest;

                                              if (isGuest) {
                                                CustomSnackBar.error(context,
                                                    "Please login to continue");
                                                return;
                                              }

                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FeedCheckoutPageV2(
                                                    directBuy: true,
                                                    quantity: counter,
                                                    productItem: productItem,
                                                  ),
                                                ),
                                              );
                                            }),
                                  kHeight30
                                ],
                              ),
                            ));
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

String formatNumber(num value) {
  return value.toStringAsFixed(5).replaceFirst(RegExp(r'\.?0+$'), '');
}

String _formatDate(String? isoDate) {
  if (isoDate == null) return "";
  final date = DateTime.tryParse(isoDate);
  if (date == null) return "";
  return "${date.day.toString().padLeft(2, '0')} "
      "${_monthName(date.month)}";
}

String _monthName(int month) {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return months[month - 1];
}
