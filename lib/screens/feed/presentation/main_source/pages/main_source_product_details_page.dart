import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/main_source/main_source_cart_cubit.dart';
import '../../../application/main_source/main_source_product_details_cubit.dart';
import '../../../domain/entities/main_source/main_source_params.dart';
import '../../../domain/entities/main_source/main_source_product_model.dart';
import '../../distributor/utils/distributor_style.dart';
import '../../distributor/widgets/distributor_common_widgets.dart';
import '../utils/main_source_errors.dart';
import '../widgets/main_source_cart_listener.dart';
import 'main_source_checkout_page.dart';

/// Opens a product on the root navigator.
Future<void> openMainSourceProduct(BuildContext context, int productId,
        {MainSourceProductModel? initial}) =>
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (_) =>
          MainSourceProductDetailsPage(productId: productId, initial: initial),
    ));

/// Product page: gallery, size chips (variants), quantity, Add to cart and
/// Buy now (plan §2 / §3).
class MainSourceProductDetailsPage extends StatelessWidget {
  final int productId;
  final MainSourceProductModel? initial;

  const MainSourceProductDetailsPage({
    super.key,
    required this.productId,
    this.initial,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MainSourceProductDetailsCubit>()
        ..load(productId, initial: initial),
      child: const MainSourceCartListener(child: _DetailsView()),
    );
  }
}

class _DetailsView extends StatefulWidget {
  const _DetailsView();

  @override
  State<_DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<_DetailsView> {
  int? _variantId;
  int _qty = 1;
  int _page = 0;

  MainSourceVariantModel? _variant(MainSourceProductModel product) =>
      product.variants.where((v) => v.id == _variantId).firstOrNull ??
      product.defaultVariant;

  bool _guardGuest() {
    if (context.read<AuthCubit>().isGuest) {
      CustomSnackBar.error(context, 'Please login to continue');
      return true;
    }
    return false;
  }

  void _add(MainSourceVariantModel variant) {
    if (_guardGuest() || variant.id == null) return;
    context.read<MainSourceCartCubit>().addToCart(variant.id!, quantity: _qty);
  }

  /// "Buy now" does not use the cart (plan §3).
  void _buyNow(MainSourceVariantModel variant) {
    if (_guardGuest() || variant.id == null) return;
    openMainSourceCheckout(context,
        buyNow: MainSourceBuyNow(variantId: variant.id!, quantity: _qty));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainSourceProductDetailsCubit,
        MainSourceProductDetailsState>(
      builder: (context, state) {
        final product = state.product;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  size: 16, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: product == null
              ? (state.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: DistributorStyle.green))
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                            state.notFound
                                ? 'This product is no longer available.'.tr()
                                : mainSourceErrorText(state.error ?? ''),
                            textAlign: TextAlign.center,
                            style: DistributorStyle.style(size: 14)),
                      ),
                    ))
              : _body(product),
          bottomNavigationBar: product == null || _variant(product) == null
              ? null
              : _bottomBar(_variant(product)!),
        );
      },
    );
  }

  Widget _body(MainSourceProductModel product) {
    final images = product.gallery;
    final variant = _variant(product);
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
              Text(product.name,
                  style: DistributorStyle.style(
                      size: 15, weight: FontWeight.w500)),
              const SizedBox(height: 6),
              if (variant != null) ...[
                if (variant.hasDiscount) ...[
                  RiyalAmount(variant.originalPrice,
                      size: 15,
                      weight: FontWeight.w300,
                      color: DistributorStyle.muted,
                      strike: true),
                  const SizedBox(height: 4),
                ],
                RiyalAmount(variant.price, size: 15),
              ],
            ],
          ),
        ),
        const _Divider(),
        _InfoRow(
            label: 'Main Source', value: product.mainSource?.name ?? ''),
        if (product.category != null)
          _InfoRow(label: 'Category', value: product.category!.name),
        if (variant != null)
          _InfoRow(
            label: 'Availability',
            value: variant.isAvailable
                ? '${'In stock'.tr()} (${variant.stock})'
                : 'Out of stock'.tr(),
            valueColor: variant.isAvailable
                ? DistributorStyle.green
                : DistributorStyle.error,
          ),
        if (product.variants.isNotEmpty) ...[
          const _Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Size'.tr(),
                style:
                    DistributorStyle.style(size: 17, weight: FontWeight.w500)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final v in product.variants)
                  _SizeChip(
                    variant: v,
                    selected: v.id == variant?.id,
                    onTap: () => setState(() {
                      _variantId = v.id;
                      if (_qty > v.stock && v.stock > 0) _qty = v.stock;
                    }),
                  ),
              ],
            ),
          ),
        ],
        const _Divider(),
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

  Widget _bottomBar(MainSourceVariantModel variant) {
    final unavailable = !variant.isAvailable;
    return BlocBuilder<MainSourceCartCubit, MainSourceCartState>(
      buildWhen: (p, c) => p.loading != c.loading,
      builder: (context, cart) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
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
                        opacity: unavailable ? .5 : 1,
                        child: GestureDetector(
                          onTap: unavailable || cart.loading
                              ? null
                              : () => _add(variant),
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
                                  child: RiyalAmount(variant.price * _qty),
                                ),
                                const Spacer(),
                                Flexible(
                                  child: Text(
                                    unavailable
                                        ? 'Out of stock'.tr()
                                        : 'Add to cart'.tr(),
                                    overflow: TextOverflow.ellipsis,
                                    style: DistributorStyle.style(
                                        size: 11, weight: FontWeight.w500),
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded,
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
                      onIncrement: !unavailable && _qty < variant.stock
                          ? () => setState(() => _qty++)
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                  title: 'Buy now',
                  onTap: unavailable ? null : () => _buyNow(variant),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SizeChip extends StatelessWidget {
  final MainSourceVariantModel variant;
  final bool selected;
  final VoidCallback onTap;

  const _SizeChip({
    required this.variant,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = !variant.isAvailable
        ? DistributorStyle.muted
        : selected
            ? DistributorStyle.green
            : DistributorStyle.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? DistributorStyle.greenTint : Colors.white,
          border: Border.all(color: color, width: selected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(variant.size ?? '-',
                style: DistributorStyle.style(
                    size: 13, weight: FontWeight.w500, color: color)),
            if (!variant.isAvailable)
              Text('Out of stock'.tr(),
                  style: DistributorStyle.style(
                      size: 10, color: DistributorStyle.error))
            else
              RiyalAmount(variant.price, size: 11, color: color),
          ],
        ),
      ),
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
