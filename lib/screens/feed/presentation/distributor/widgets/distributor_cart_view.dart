import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_png_images.dart';
import 'package:ufc_mobile/global/extensions/saudi_riyal_icon.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/show_confirmation_dailog.dart';
import 'package:ufc_mobile/screens/feed/presentation/product/widgets/cart/empty_cart_widget.dart';

import '../../../application/distributor/distributor_cart_cubit.dart';
import '../../../domain/entities/distributor/distributor_cart_model.dart';
import '../pages/distributor_checkout_page.dart';
import '../utils/distributor_style.dart';
import 'distributor_cart_listener.dart';
import 'distributor_common_widgets.dart';

/// "Distributors" tab of the cart screen.
class DistributorCartView extends StatefulWidget {
  final VoidCallback onShopNow;

  const DistributorCartView({super.key, required this.onShopNow});

  @override
  State<DistributorCartView> createState() => _DistributorCartViewState();
}

class _DistributorCartViewState extends State<DistributorCartView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<DistributorCartCubit>().fetchCart());
  }

  @override
  Widget build(BuildContext context) {
    return DistributorCartListener(
      showAdded: false,
      child: BlocBuilder<DistributorCartCubit, DistributorCartState>(
        builder: (context, state) {
          final cubit = context.read<DistributorCartCubit>();
          if (state.loading && !state.loaded) {
            return const Center(
                child:
                    CircularProgressIndicator(color: DistributorStyle.green));
          }
          if (!state.loaded && state.event == DistributorCartEvent.error) {
            return CustomReloadProviderV2(
              error: state.message,
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
              if (cart.distributor != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Row(
                    children: [
                      const TruckIcon(width: 17, height: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(cart.distributor!.name,
                            style: DistributorStyle.style(
                                size: 13, weight: FontWeight.w500)),
                      ),
                      if (!cart.distributor!.isOpen)
                        const OpenClosedChip(isOpen: false),
                    ],
                  ),
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
              _CheckoutBar(cart: cart, count: state.count),
            ],
          );
        },
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  final DistributorCartItemModel item;
  final bool busy;

  const _CartLine({required this.item, this.busy = false});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DistributorCartCubit>();
    final stock = item.stock;
    final unavailable = !item.isAvailable || (stock != null && stock <= 0);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
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
          const SizedBox(width: 18),
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
                      onTap: () async {
                        final ok = await showConfirmationDialog(
                          context: context,
                          title: 'Confirmation'.tr(),
                          content: 'Are you sure to remove this item?'.tr(),
                        );
                        if (ok && item.id != null) cubit.remove(item.id!);
                      },
                      child: const Icon(Icons.close,
                          size: 15, color: Color(0xFF0F0F0F)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('${item.quantity} X ',
                        style: DistributorStyle.style(
                            weight: FontWeight.w300,
                            color: DistributorStyle.priceGrey)),
                    RiyalAmount(item.price,
                        weight: FontWeight.w400,
                        color: DistributorStyle.priceGrey),
                  ],
                ),
                if (unavailable)
                  Text('no_stock'.tr(),
                      style: DistributorStyle.style(
                          size: 12, color: DistributorStyle.error)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QtyStepper(
                      qty: item.quantity,
                      busy: busy,
                      onDecrement: item.quantity > 1 && item.id != null
                          ? () => cubit.decrement(item.id!)
                          : null,
                      onIncrement: item.id != null &&
                              (stock == null || item.quantity < stock)
                          ? () => cubit.increment(item.id!)
                          : null,
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
  final DistributorCartModel cart;
  final int count;

  const _CheckoutBar({required this.cart, required this.count});

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
        onTap: cart.distributorId == null
            ? null
            : () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => DistributorCheckoutPage(
                      distributorId: cart.distributorId!,
                    ),
                  ),
                ),
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
                child: Text('$count',
                    style: DistributorStyle.style(weight: FontWeight.w500)),
              ),
              const SizedBox(width: 16),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(formatPrice(cart.totalAmount),
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
              Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
