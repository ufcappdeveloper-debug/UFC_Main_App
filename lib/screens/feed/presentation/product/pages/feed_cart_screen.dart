import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/common/screen_width_utils.dart';
import 'package:ufc_mobile/screens/feed/application/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/cart/feed_cart_model.dart';
import 'package:ufc_mobile/screens/feed/presentation/bottom_bar/page/feed_bottom_bar.dart';
import 'package:ufc_mobile/screens/feed/presentation/category/pages/category_screen.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/cart/cart_quantity_selector.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/cart/checkout_section.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/cart/empty_cart_widget.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/cart/price_label.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_shadows.dart';

import '../../../../../global/extensions/saudi_riyal_icon.dart';
import '../../../../../global/shared/widgets/app_image_place_holder.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../application/cart/cart_cubit.dart';
import '../../../application/cart/cart_state.dart';
import '../../../application/feed_channel/feed_channel_cubit.dart';
import '../../../application/feed_channel/feed_channel_state.dart';
import '../../distributor/widgets/cart_channel_switch.dart';
import '../../distributor/widgets/distributor_cart_view.dart';

class FeedCartScreen extends StatefulWidget {
  final bool isPush;
  const FeedCartScreen({
    super.key,
    this.isPush = false,
  });

  @override
  State<FeedCartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<FeedCartScreen> {
  List<FeedCartItemModel> cartItems = [];

  /// 0 = Station (shop) cart, 1 = Distributors cart.
  late int _tab =
      context.read<FeedChannelCubit>().state.isDistributor ? 1 : 0;

  void callApi() async {
    final cubit = context.read<CartCubit>();
    await cubit.fetchCart();
    await cubit.fetchCartCount();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi();
    });
  }

  void _shopNowTapped(int index) {
    context.read<FeedChannelCubit>().setChannel(
        _tab == 1 ? FeedChannel.distributor : FeedChannel.station);
    context.read<FeedBottomNavCubit>().changeTab(1);
    context.read<AppBarHeightCubit>().setHeight(31);
    context.read<AppBarCubit>().setMode(AppBarMode.channel);
    final imagePath = AppImages.feedSmallBg;
    context.read<FeedBackgroundCubit>().updateBackground(imagePath);
    if (index == 1) {
      CategoryScreen.categoryKey.currentState?.resetTab();
    }
  }

  Future<void> showDeleteItemDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 10,
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: primaryColor, size: 22),
            const SizedBox(width: 8),
            CustomText(
              text: "Confirmation".tr(),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CustomText(text: message),
        ),
        titlePadding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
        contentPadding:
            const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 10),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        actions: [
          // Wrap in Row for equal spacing and proper alignment
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: CustomText(
                      text: "Cancel".tr(),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Delete Button
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      onConfirm();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: primaryColor, width: 1.5),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: primaryColor, size: 18),
                        const SizedBox(width: 6),
                        CustomText(
                          text: "Delete".tr(),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
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
    );
  }

  void showSuccessSnackBar(String message) {
    if (context.mounted) {
      CustomSnackBar.success(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = ScreenWidthUtils.isWide(context);
    final isSmall = ScreenWidthUtils.isWide(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<FeedChannelCubit, FeedChannelState>(
        listenWhen: (p, c) => p.channel != c.channel,
        listener: (context, channel) =>
            setState(() => _tab = channel.isDistributor ? 1 : 0),
        child: Column(
          children: [
            CartChannelSwitch(
              selected: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            Expanded(
              child: _tab == 1
                  ? DistributorCartView(onShopNow: () => _shopNowTapped(1))
                  : _buildStationCart(context, isWide, isSmall),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationCart(BuildContext context, bool isWide, bool isSmall) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            // return const CartShimmer();
            return const Center(
                child: CircularProgressIndicator(
              color: PetVeterinaryColors.mainColorUFC,
            ));
          }

          if (state is CartError) {
            return isNetworkError(state.message)
                ? NoInternet(
                    type: AppType.feed,
                    onTap: () => callApi(),
                  )
                : Center(
                    child: CustomReloadProviderV2(
                      error: state.message,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      onPressed: () {
                        context.read<CartCubit>().fetchCart();
                        context.read<CartCubit>().fetchCartCount();
                      },
                    ),
                  );
          }

          if (state is CartLoaded) {
            cartItems = state.cartItems;
            final totalAmount = state.totalAmount;

            final formattedAmount = formatNumber(totalAmount ?? 0);

            if (cartItems.isEmpty) {
              return EmptyCartWidget(
                text: "The shopping basket is empty",
                imagePath: AppPngImages.emptyCartImg,
                onButtonPressed: () {
                  _shopNowTapped(1);
                },
                buttonText: "Shop Now",
              );
            }

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context.read<CartCubit>().fetchCart();
                      await context.read<CartCubit>().fetchCartCount();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final product = item.variant?.product;
                        final imageUrl = product?.images?.isNotEmpty == true
                            ? product!.images!.first.location
                            : "";
                        final name = isEnglish
                            ? product?.nameEn ?? "—"
                            : product?.nameAr ?? "—";
                        final unitPrice = item.variant?.price ?? 0;
                        final qty = item.quantity ?? 0;
                        final total =
                            double.parse((unitPrice * qty).toStringAsFixed(5));

                        final productImage = ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageWithPlaceHolder(
                            imageUrl: imageUrl,
                            width: 67,
                            height: 87,
                            fit: BoxFit
                                .fill, // stretches image to occupy the entire box
                          ),
                        );

                        final removeButton = InkWell(
                          borderRadius: BorderRadius.circular(
                              20), // 👈 adds a subtle ripple shape
                          onTap: () {
                            showDeleteItemDialog(
                              context: context,
                              message: isEnglish
                                  ? "Are you sure to remove this item?"
                                  : "هل أنت متأكد من إزالة هذا العنصر؟",
                              onConfirm: () async {
                                await context
                                    .read<CartCubit>()
                                    .removeFromCart(item.id!);

                                showSuccessSnackBar(isEnglish
                                    ? "Item removed successfully"
                                    : "تمت إزالة العنصر بنجاح");
                              },
                            );
                          },
                          child: Icon(
                            Icons.close,
                            color: PetVeterinaryColors.blackground2,
                            size: 15,
                          ),
                        );

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: PetVeterinaryShadows.standardLight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                productImage,
                                SizedBox(width: isWide ? 28 : 18),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: name,
                                            // textAlign: TextAlign.start,
                                            fontSize: isWide ? 15 : 13,
                                            height: isWide ? 2 : 1.6,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          removeButton,
                                        ],
                                      ),
                                      PriceLabel(
                                        qty: qty,
                                        unitPrice: unitPrice,
                                        isArOrUr: isArOrUr,
                                        isWide: isWide,
                                      ),
                                      kHeight10,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Transform.translate(
                                            offset:
                                                Offset(isEnglish ? -6 : 6, 0),
                                            child: CartQuantitySelector(
                                              qty: qty,
                                              itemId: item.id!,
                                              isWide: isWide,
                                              isSmall: isSmall,
                                            ),
                                          ),
                                          Flexible(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CustomText(
                                                  text:
                                                      total.toStringAsFixed(2),
                                                  fontSize: isWide ? 15 : 13,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SaudiRiyalIcon(
                                                    size: isWide ? 14 : 13),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                CheckoutSection(
                  cartItems: cartItems,
                  formattedAmount: formattedAmount,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String formatNumber(num value) {
    return value.toStringAsFixed(5).replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
