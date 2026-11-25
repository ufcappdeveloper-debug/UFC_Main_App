import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/show_confirmation_dailog.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/cart/empty_cart_widget.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/quantity_selector.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/main_source/main_source_cart_cubit.dart';
import '../../../domain/entities/main_source/main_source_cart_model.dart';
import '../../distributor/utils/distributor_style.dart';
import '../../distributor/widgets/distributor_common_widgets.dart';
import '../pages/main_source_checkout_page.dart';
import '../utils/main_source_errors.dart';
import 'main_source_cart_listener.dart';

/// The Cart tab in Main Source mode (no Station / Distributor switch).
class MainSourceCartView extends StatefulWidget {
  final VoidCallback onShopNow;

  const MainSourceCartView({super.key, required this.onShopNow});

  @override
  State<MainSourceCartView> createState() => _MainSourceCartViewState();
}

class _MainSourceCartViewState extends State<MainSourceCartView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.read<AuthCubit>().isGuest) {
        context.read<MainSourceCartCubit>().fetchCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<AuthCubit>().isGuest) {
      return EmptyCartWidget(
        text: 'Please login to continue',
        imagePath: AppPngImages.emptyCartImg,
        onButtonPressed: widget.onShopNow,
        buttonText: 'Shop Now',
      );
    }
    return MainSourceCartListener(
      showAdded: false,
      child: BlocBuilder<MainSourceCartCubit, MainSourceCartState>(
        builder: (context, state) {
          final cubit = context.read<MainSourceCartCubit>();
          if (state.loading && !state.loaded) {
            return const Center(
                child:
                    CircularProgressIndicator(color: DistributorStyle.green));
          }
          if (!state.loaded && state.event == MainSourceCartEvent.error) {
            return CustomReloadProviderV2(
              error: state.error == null ? null : mainSourceErrorText(state.error!),
              height: 120,
              decoration: const BoxDecoration(color: Colors.transparent),
              onPressed: cubit.fetchCart,
            );
          }
          final cart = state.cart;
          if (cart.isEmpty) {
            return EmptyCartWidget(
              text: 'The shopping basket is empty',
              imagePath: AppPngImages.emptyCartImg,
              onButtonPressed: widget.onShopNow,
              buttonText: 'Shop Now',
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
                child: Row(
                  children: [
                    const Icon(Icons.storefront_outlined,
                        size: 16, color: DistributorStyle.green),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(cart.mainSource?.name ?? '',
                          style: DistributorStyle.style(
                              size: 13, weight: FontWeight.w500)),
                    ),
                    TextButton(
                      onPressed: () async {
                        final ok = await showConfirmationDialog(
                          context: context,
                          title: 'Confirmation'.tr(),
                          content: 'Remove all items from the cart?'.tr(),
                        );
                        if (ok) cubit.clear();
                      },
                      child: Text('Clear cart'.tr(),
                          style: DistributorStyle.style(
                              size: 12, color: DistributorStyle.error)),
                    ),
                  ],
                ),
              ),
              if (cart.hasUnavailableItems)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: DistributorStyle.error.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                      'Some items are not available in the requested quantity.'
                          .tr(),
                      style: DistributorStyle.style(
                          size: 12, color: DistributorStyle.error)),
                ),
              Expanded(
                child: RefreshIndicator(
                  color: DistributorStyle.green,
                  onRefresh: () => cubit.fetchCart(silent: true),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.items.length,
                    itemBuilder: (context, i) => _CartLine(
                      item: cart.items[i],
                      busy: state.updatingItemIds.contains(cart.items[i].id),
                    ),
                  ),
                ),
              ),
              _CheckoutBar(cart: cart),
            ],
          );
        },
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  final MainSourceCartItemModel item;
  final bool busy;

  const _CartLine({required this.item, this.busy = false});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MainSourceCartCubit>();
    final unavailable = !item.isAvailable;
    final id = item.id;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: unavailable ? Border.all(color: DistributorStyle.error) : null,
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 6,
              spreadRadius: .2,
              offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageWithPlaceHolder(
                imageUrl: item.image, width: 67, height: 87, fit: BoxFit.fill),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: DistributorStyle.style()
                              .copyWith(height: 1.6)),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: id == null || busy
                          ? null
                          : () async {
                              final ok = await showConfirmationDialog(
                                context: context,
                                title: 'Confirmation'.tr(),
                                content:
                                    'Are you sure to remove this item?'.tr(),
                              );
                              if (ok) cubit.remove(id);
                            },
                      child: const Icon(Icons.close,
                          size: 15, color: Color(0xFF0F0F0F)),
                    ),
                  ],
                ),
                if ((item.size ?? '').isNotEmpty)
                  Text(item.size!,
                      style: DistributorStyle.style(
                          size: 12, color: DistributorStyle.priceGrey)),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text('${item.quantity} X',
                        style: DistributorStyle.style(
                            weight: FontWeight.w300,
                            color: DistributorStyle.priceGrey)),
                    if (item.hasDiscount)
                      RiyalAmount(item.originalPrice,
                          size: 12,
                          weight: FontWeight.w300,
                          color: DistributorStyle.error,
                          strike: true),
                    RiyalAmount(item.unitPrice,
                        weight: FontWeight.w400,
                        color: DistributorStyle.priceGrey),
                  ],
                ),
                if (unavailable)
                  Text(
                    item.stock > 0 && item.stock < item.quantity
                        ? 'ms_only_left_in_stock'.tr(namedArgs: {
                            'available_quantity': '${item.stock}'
                          })
                        : 'This product is no longer available.'.tr(),
                    style: DistributorStyle.style(
                        size: 12, color: DistributorStyle.error),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QtyStepper(
                      qty: item.quantity,
                      busy: busy,
                      onDecrement: item.quantity > 1 && id != null
                          ? () => cubit.setQuantity(id, item.quantity - 1)
                          : null,
                      onIncrement: id != null && item.quantity < item.stock
                          ? () => cubit.setQuantity(id, item.quantity + 1)
                          : null,
                    ),
                    if (id != null)
                      GestureDetector(
                        onTap: busy
                            ? null
                            : () => showCustomQuantitySheet(
                                  context,
                                  stock: item.stock,
                                  initialQuantity: item.quantity,
                                  onSaved: (qty) {
                                    if (qty != item.quantity) {
                                      cubit.setQuantity(id, qty);
                                    }
                                  },
                                ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Text('Customize'.tr(),
                              style: DistributorStyle.style(
                                  size: 13, color: DistributorStyle.green)),
                        ),
                      ),
                    Flexible(child: RiyalAmount(item.total, size: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final MainSourceCartModel cart;

  const _CheckoutBar({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x269E9E9E),
              offset: Offset(0, -1),
              blurRadius: 2.5,
              spreadRadius: .6),
        ],
      ),
      child: GestureDetector(
        onTap: () => openMainSourceCheckout(context),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: DistributorStyle.yellow,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: Text('${cart.quantity}',
                    style: DistributorStyle.style(weight: FontWeight.w500)),
              ),
              const SizedBox(width: 16),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(formatPrice(cart.subtotal),
                        style: DistributorStyle.style(
                            size: 15, weight: FontWeight.w500)),
                    const SizedBox(width: 2),
                    const SaudiRiyalIcon(size: 16),
                  ],
                ),
              ),
              const Spacer(),
              Text('Checkout'.tr(),
                  style:
                      DistributorStyle.style(size: 12, weight: FontWeight.w500)),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
