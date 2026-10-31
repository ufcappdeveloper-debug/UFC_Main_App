import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/app_svg_images.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/distributor/distributor_cart_cubit.dart';
import '../../../application/distributor/distributor_product_details_cubit.dart';
import '../../../domain/entities/distributor/distributor_cart_model.dart';
import '../../../domain/entities/distributor/distributor_model.dart';
import '../../../domain/entities/distributor/distributor_product_model.dart';
import '../../product/widgets/quantity_selector.dart';
import '../utils/distributor_style.dart';
import '../widgets/distributor_cart_listener.dart';
import '../widgets/distributor_common_widgets.dart';
import 'distributor_checkout_page.dart';
import '../../../application/distributor/distributor_checkout_cubit.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/util/common/screen_width_utils.dart';

/// Distributor product page (design: "Feed - Product Details", without the
/// bag-size picker: distributor products have a single variant).
class DistributorProductDetailsPage extends StatelessWidget {
  final int productId;
  final DistributorProductModel? initial;
  final DistributorModel? distributor;

  const DistributorProductDetailsPage({
    super.key,
    required this.productId,
    this.initial,
    this.distributor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DistributorProductDetailsCubit>()
        ..load(productId, initial: initial),
      child: DistributorCartListener(
        child: _DetailsView(distributor: distributor),
      ),
    );
  }
}

class _DetailsView extends StatefulWidget {
  final DistributorModel? distributor;

  const _DetailsView({this.distributor});

  @override
  State<_DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<_DetailsView> {
  int _qty = 1;
  int _page = 0;

  bool _guardGuest() {
    if (context.read<AuthCubit>().isGuest) {
      CustomSnackBar.error(context, 'Please login to continue');
      return true;
    }
    return false;
  }

  /// "Order Now": buy this product directly (distributor/buy_product),
  /// without the distributor cart.
  void _orderNow(DistributorProductModel product) {
    if (_guardGuest() || product.variant?.id == null) return;
    final distributorId = widget.distributor?.id ?? product.distributorId;
    if (distributorId == null) return;
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => DistributorCheckoutPage(
          distributorId: distributorId,
          direct: DirectBuyItem(
            product: product,
            variantId: product.variant!.id!,
            quantity: _qty,
          ),
        ),
      ),
    );
  }

  void _add(DistributorProductModel product) {
    if (_guardGuest() || product.variant?.id == null) return;
    context.read<DistributorCartCubit>().addToCart(AddDistributorCartParams(
          productId: product.id!,
          variantId: product.variant!.id!,
          quantity: _qty,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DistributorProductDetailsCubit,
        DistributorProductDetailsState>(
      builder: (context, state) {
        final product = state.product;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: product == null
              ? (state.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: DistributorStyle.green))
                  : Center(
                      child: Text(state.error ?? '',
                          style: DistributorStyle.style())))
              : _body(product),
          bottomNavigationBar: product == null ? null : _bottomBar(product),
        );
      },
    );
  }

  Widget _body(DistributorProductModel product) {
    final images = product.images.map((e) => e.location).whereType<String>();
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            color: Color(0x1AC5C5C5),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
          clipBehavior: Clip.antiAlias,
          child: images.isEmpty
              ? const ImageWithPlaceHolder(
                  width: double.infinity, height: 250, fit: BoxFit.contain)
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView(
                      onPageChanged: (i) => setState(() => _page = i),
                      children: [
                        for (final url in images)
                          ImageWithPlaceHolder(
                              imageUrl: url,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.contain),
                      ],
                    ),
                    if (images.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            images.length,
                            (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i == _page
                                    ? DistributorStyle.green
                                    : DistributorStyle.muted,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(product.name,
                        style: DistributorStyle.style(
                            size: 15, weight: FontWeight.w500)),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_guardGuest()) return;
                      context
                          .read<DistributorProductDetailsCubit>()
                          .toggleFavorite();
                    },
                    child: SvgPicture.asset(
                      product.favorite
                          ? AppSvgImages.chosenFavoriteIcon
                          : AppSvgImages.favoriteIcon,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (product.isOffer) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: DistributorStyle.yellow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('${product.discountPercent}%',
                          style: DistributorStyle.style(size: 9)),
                    ),
                    const SizedBox(width: 6),
                    RiyalAmount(product.originalPrice,
                        size: 15,
                        weight: FontWeight.w300,
                        color: DistributorStyle.muted,
                        strike: true),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              RiyalAmount(product.price, size: 15),
            ],
          ),
        ),
        const _Divider(),
        _InfoRow(
            label: 'Distributor',
            value: widget.distributor?.name ?? product.distributorName),
        if ((product.variant?.size ?? '').isNotEmpty)
          _InfoRow(label: 'Size', value: product.variant!.size!),
        _InfoRow(
          label: 'Availability',
          value: product.isOutOfStock
              ? 'no_stock'.tr()
              : '${'In stock'.tr()} (${product.stock})',
          valueColor: product.isOutOfStock
              ? DistributorStyle.error
              : DistributorStyle.green,
        ),
        const _Divider(),
        if (!product.isOutOfStock) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Select number of bags'.tr(),
                style:
                    DistributorStyle.style(size: 17, weight: FontWeight.w500)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: QuantitySelector(
              isWide: ScreenWidthUtils.isWide(context),
              stock: product.stock,
              initialQuantity: _qty,
              onSelected: (qty) => setState(() => _qty = qty),
            ),
          ),
          const _Divider(),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Description'.tr(),
              style: DistributorStyle.style(size: 17, weight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Text(
            product.description.isEmpty
                ? 'Not specified'.tr()
                : product.description,
            style: DistributorStyle.style(
                size: 15, color: DistributorStyle.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _bottomBar(DistributorProductModel product) {
    final outOfStock = product.isOutOfStock;
    final maxQty = product.stock;
    return BlocBuilder<DistributorCartCubit, DistributorCartState>(
      buildWhen: (p, c) => p.loading != c.loading,
      builder: (context, cart) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color(0x269E9E9E),
                  blurRadius: 2.5,
                  spreadRadius: .6,
                  offset: Offset(0, -1)),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Opacity(
                        opacity: outOfStock ? .5 : 1,
                        child: GestureDetector(
                          onTap: outOfStock || cart.loading
                              ? null
                              : () => _add(product),
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: DistributorStyle.yellow,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: cart.loading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: DistributorStyle.green))
                                      : Text('$_qty',
                                          style: DistributorStyle.style(
                                              size: 12,
                                              weight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 10),
                                Directionality(
                                  textDirection: ui.TextDirection.ltr,
                                  child: RiyalAmount(product.price * _qty),
                                ),
                                const Spacer(),
                                Flexible(
                                  child: Text(
                                    outOfStock
                                        ? 'no_stock'.tr()
                                        : (_qty == 1 ? 'Add item' : 'Add items')
                                            .tr(),
                                    overflow: TextOverflow.ellipsis,
                                    style: DistributorStyle.style(
                                        size: 11, weight: FontWeight.w500),
                                  ),
                                ),
                                Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    QtyStepper(
                      qty: _qty,
                      onDecrement:
                          _qty > 1 ? () => setState(() => _qty--) : null,
                      onIncrement: !outOfStock && _qty < maxQty
                          ? () => setState(() => _qty++)
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Same button as the station product page.
                CustomButton(
                  fontWeight: FontWeight.w400,
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                  height: 45,
                  radius: 22.5,
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  textColor: primaryColor,
                  color: Colors.white,
                  border: Border.all(color: primaryColor),
                  title: 'Order Now',
                  onTap: outOfStock ? null : () => _orderNow(product),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child:
            Divider(height: .25, thickness: .25, color: DistributorStyle.muted),
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(label.tr(),
              style: DistributorStyle.style(
                  size: 14,
                  weight: FontWeight.w300,
                  color: DistributorStyle.textSecondary)),
          const Spacer(),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: DistributorStyle.style(
                    size: 14, color: valueColor ?? DistributorStyle.text)),
          ),
        ],
      ),
    );
  }
}
