import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/bank_account_card.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/data/payment_service.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';
import 'package:ufc_mobile/screens/feed_old/payment/pages/mada_payment_screen.dart';
import 'package:ufc_mobile/screens/feed/application/authentication/auth_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/address/address_cubit.dart';
import 'package:ufc_mobile/screens/feed/application/address/address_state.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_checkout_default_address.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_date_widget.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/feed_delivery_note.dart';
import 'package:ufc_mobile/screens/feed/presentation/checkout/widgets/vehicle_number_widget.dart';
import 'package:ufc_mobile/screens/feed/presentation/profile/pages/feed_address_page.dart';

import '../../../application/distributor/distributor_cart_cubit.dart';
import '../../../application/distributor/distributor_checkout_cubit.dart';
import '../../../domain/entities/distributor/checkout_options_model.dart';
import '../../../domain/entities/distributor/distributor_cart_model.dart';
import '../../../domain/entities/distributor/distributor_place_order_result.dart';
import '../utils/distributor_style.dart';
import '../widgets/distributor_common_widgets.dart';
import 'distributor_order_success_page.dart';

/// Distributor checkout. Order types and payment methods are whatever the
/// distributor switched on (`checkout_options`).
/// - Cart mode: totals from `checkout_summary`, order via `place_order`.
/// - Direct mode ([direct], "Order Now"): one product via `buy_product`,
///   totals estimated on the device, the cart is left untouched.
class DistributorCheckoutPage extends StatelessWidget {
  final int distributorId;
  final DirectBuyItem? direct;

  const DistributorCheckoutPage(
      {super.key, required this.distributorId, this.direct});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<DistributorCheckoutCubit>()..start(distributorId, direct: direct),
      child: const _CheckoutView(),
    );
  }
}

/// Direct-buy totals computed on the device (there is no single-product
/// checkout_summary). The server recalculates everything; display only.
class _Estimate {
  final double items;
  final double vat;
  final double deliveryFee;
  final double deliveryVat;

  const _Estimate(this.items, this.vat, this.deliveryFee, this.deliveryVat);

  double get total => items + vat + deliveryFee + deliveryVat;

  static _Estimate? of(BuildContext context, DistributorCheckoutState state) {
    final direct = context.read<DistributorCheckoutCubit>().direct;
    if (direct == null) return null;
    // Same VAT source as the station checkout.
    final vatRate =
        (context.read<AuthCubit>().currentUser?.vatPercentage ?? 0) / 100;
    final items = direct.itemsTotal;
    final fee = (state.selectedOrderType?.isDelivery ?? false)
        ? (state.selectedOrderType?.fee ?? 0)
        : 0.0;
    return _Estimate(items, items * vatRate, fee, fee * vatRate);
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView();

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final _couponCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  String? _note;
  DateTime? _deliveryDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressCubit>().getDefaultAddress();
    });
  }

  @override
  void dispose() {
    _couponCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  int? get _addressId {
    final state = context.read<AddressCubit>().state;
    return state is AddressLoaded ? state.defaultAddress?.id : null;
  }

  void _placeOrder({bool force = false}) {
    final checkout = context.read<DistributorCheckoutCubit>();
    if (checkout.state.isDelivery && _addressId == null) {
      CustomSnackBar.error(context, 'An address is required for checkout*');
      return;
    }
    checkout.placeOrder(
      force: force,
      addressId: _addressId,
      note: _note,
      driverPlate: _plateCtrl.text.trim(),
      bookingDateTime: _deliveryDate == null
          ? null
          : DateFormat('dd-MM-yyyy HH:mm', 'en').format(_deliveryDate!),
    );
  }

  Future<void> _onStockError(DistributorApiException error) async {
    final cart = context.read<DistributorCartCubit>();
    final line = cart.state.cart.items
        .where((e) => e.distributorVariantId == error.variantId)
        .firstOrNull;
    final canLower = error.isStockLimit &&
        (error.availableStock ?? 0) > 0 &&
        line?.id != null;
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Stock changed'.tr(),
            style: DistributorStyle.style(size: 16, weight: FontWeight.w600)),
        content: Text(error.message, style: DistributorStyle.style()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('remove'),
            child: Text('Skip unavailable items'.tr(),
                style: const TextStyle(color: DistributorStyle.error)),
          ),
          if (canLower)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('lower'),
              child: Text(
                  'set_quantity_to'
                      .tr(namedArgs: {'n': '${error.availableStock}'}),
                  style: const TextStyle(color: DistributorStyle.green)),
            ),
        ],
      ),
    );
    if (!mounted) return;
    if (choice == 'remove') {
      _placeOrder(force: true);
    } else if (choice == 'lower' && line?.id != null) {
      await cart.setQuantity(line!.id!, error.availableStock!);
      if (mounted) context.read<DistributorCheckoutCubit>().refreshSummary();
    }
  }

  Future<void> _onSuccess(DistributorPlaceOrderResult result) async {
    final isDirect = context.read<DistributorCheckoutCubit>().direct != null;
    // MADA/CARD: pay first, exactly like the station flow.
    if (result.needsCardPayment) {
      final paid = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MadaPaymentScreen(
            integrity: result.integrity!,
            checkoutId: result.checkoutId!,
            languageLocale: LanguageManager.locale,
          ),
        ),
      );
      if (!mounted) return;
      if (paid != true) {
        CustomSnackBar.error(
            context, 'Payment was not completed. Please try again.');
        return;
      }
      final verified = await LoadingDialog.show(
          context, PaymentService.verifyPayment(result.checkoutId!));
      if (!mounted) return;
      if (!verified) {
        CustomSnackBar.error(context,
            'Payment verification failed. If the amount was deducted, please contact support.');
        return;
      }
    }
    // A direct buy doesn't touch the distributor cart.
    if (!isDirect) {
      context.read<DistributorCartCubit>().fetchCart(silent: true);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => DistributorOrderSuccessPage(result: result),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DistributorCheckoutCubit, DistributorCheckoutState>(
      listenWhen: (p, c) => p.eventId != c.eventId,
      listener: (context, state) {
        if (state.result != null) {
          _onSuccess(state.result!);
        } else if (state.stockError != null) {
          _onStockError(state.stockError!);
        } else if (state.error != null) {
          CustomSnackBar.error(context, state.error!);
        }
      },
      builder: (context, state) {
        final cart = context.watch<DistributorCartCubit>().state.cart;
        final direct = context.read<DistributorCheckoutCubit>().direct;
        final estimate = _Estimate.of(context, state);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text('Checkout'.tr(),
                style:
                    DistributorStyle.style(size: 15, weight: FontWeight.w500)),
            leading: IconButton(
              icon: Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: state.loadingOptions && state.options == null
              ? const Center(
                  child:
                      CircularProgressIndicator(color: DistributorStyle.green))
              : ListView(
                  padding: const EdgeInsets.only(bottom: 20),
                  children: [
                    if (!state.isOpen) const _ClosedBanner(),
                    if (direct != null)
                      _DirectLine(item: direct)
                    else
                      _OrderLines(
                          cart: cart, outOfStock: state.outOfStockVariantIds),
                    const SizedBox(height: 12),
                    _OrderTypes(state: state),
                    if (state.selectedOrderType?.isPickup ?? false)
                      _PickupDetails(
                          option: state.selectedOrderType!,
                          plateCtrl: _plateCtrl),
                    if (state.isDelivery) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _AddressSection(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DeliveryDatePicker(
                            onDateSelected: (d) => _deliveryDate = d),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: DeliveryNoteWidget(
                          deliveryNote: _note,
                          onNoteSaved: (n) => setState(() => _note = n),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _CouponField(controller: _couponCtrl, state: state),
                    const SizedBox(height: 20),
                    _PaymentMethods(state: state),
                    const SizedBox(height: 10),
                    _Totals(
                      state: state,
                      itemCount: direct != null ? 1 : cart.items.length,
                      estimate: estimate,
                    ),
                  ],
                ),
          bottomNavigationBar: _BottomBar(
            state: state,
            estimate: estimate,
            onPlaceOrder: state.canPlaceOrder ? () => _placeOrder() : null,
          ),
        );
      },
    );
  }
}

class _ClosedBanner extends StatelessWidget {
  const _ClosedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DistributorStyle.error.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: DistributorStyle.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text('This distributor is not taking orders right now'.tr(),
                style: DistributorStyle.style(color: DistributorStyle.error)),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets margin;

  const _Section({
    this.title,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: DistributorStyle.card(radius: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!.tr(),
                style:
                    DistributorStyle.style(size: 15, weight: FontWeight.w500)),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _OrderLines extends StatelessWidget {
  final DistributorCartModel cart;
  final List<int> outOfStock;

  const _OrderLines({required this.cart, required this.outOfStock});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'My Order',
      margin: const EdgeInsets.fromLTRB(20, 13, 20, 0),
      child: Column(
        children: [
          for (final item in cart.items) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: DistributorStyle.style()),
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
                        if (outOfStock.contains(item.distributorVariantId))
                          Text('no_stock'.tr(),
                              style: DistributorStyle.style(
                                  size: 12, color: DistributorStyle.error)),
                      ],
                    ),
                  ),
                  RiyalAmount(item.total, size: 15, weight: FontWeight.w400),
                ],
              ),
            ),
            if (item != cart.items.last)
              const Divider(
                  height: 16, thickness: .25, color: DistributorStyle.muted),
          ],
        ],
      ),
    );
  }
}

class _OrderTypes extends StatelessWidget {
  final DistributorCheckoutState state;

  const _OrderTypes({required this.state});

  @override
  Widget build(BuildContext context) {
    final types = state.options?.orderTypes ?? [];
    if (types.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          for (final type in types) ...[
            Expanded(child: _OrderTypeTile(option: type, state: state)),
            if (type != types.last) const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }
}

class _OrderTypeTile extends StatelessWidget {
  final OrderTypeOption option;
  final DistributorCheckoutState state;

  const _OrderTypeTile({required this.option, required this.state});

  @override
  Widget build(BuildContext context) {
    final selected = state.orderType == option.code;
    final accent =
        option.isPickup ? DistributorStyle.green : DistributorStyle.yellow;
    final icon = SvgPicture.asset(
      option.isPickup
          ? 'assets/svg/feed/pickup.svg'
          : 'assets/svg/feed/truck.svg',
      width: option.isPickup ? 36 : 30,
      height: option.isPickup ? 36 : 30,
      colorFilter:
          ColorFilter.mode(selected ? accent : Colors.black, BlendMode.srcIn),
    );
    return GestureDetector(
      onTap: () => context
          .read<DistributorCheckoutCubit>()
          .selectOrderType(option.code!),
      child: Container(
        constraints: const BoxConstraints(minHeight: 81),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? (option.isPickup
                  ? const Color(0x2878B833)
                  : const Color(0x19F7D66D))
              : Colors.white,
          border: Border.all(
              color: selected
                  ? (option.isPickup
                      ? DistributorStyle.tabGreen
                      : DistributorStyle.yellow)
                  : const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            option.isPickup || isArOrUr
                ? icon
                : Transform.flip(flipX: true, child: icon),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.label, style: DistributorStyle.style()),
                  if (option.isDelivery && option.fee != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('+ ',
                            style: DistributorStyle.style(
                                size: 12,
                                color: DistributorStyle.textSecondary)),
                        RiyalAmount(option.fee,
                            size: 12,
                            weight: FontWeight.w300,
                            color: DistributorStyle.textSecondary),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickupDetails extends StatelessWidget {
  final OrderTypeOption option;
  final TextEditingController plateCtrl;

  const _PickupDetails({required this.option, required this.plateCtrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 18),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: DistributorStyle.card(radius: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/feed/location.svg',
                      width: 16, height: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(option.label,
                        style: DistributorStyle.style(
                            size: 15, weight: FontWeight.w500)),
                  ),
                ],
              ),
              if ((option.subtitle ?? '').isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(option.subtitle!,
                    style: DistributorStyle.style(
                        color: DistributorStyle.textSecondary)),
              ],
              if (option.hasLocation) ...[
                const SizedBox(height: 14),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: MapChip(
                    latitude: option.latitude!,
                    longitude: option.longitude!,
                    title: option.subtitle ?? option.label,
                    label: 'Show on map',
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        VehicleNumberWidget(controller: plateCtrl),
      ],
    );
  }
}

class _AddressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        final defaultAddress =
            state is AddressLoaded ? state.defaultAddress : null;
        return FeedCheckoutDefaultAddress(
          defaultAddress: defaultAddress,
          isLoading: state is AddressLoading,
          errorMessage: state is AddressError ? state.message : null,
          onAddAddressPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddressScreen(currentDefaultAddressId: defaultAddress?.id),
            ),
          ).then((_) {
            if (context.mounted) {
              context.read<AddressCubit>().getDefaultAddress();
            }
          }),
        );
      },
    );
  }
}

class _CouponField extends StatelessWidget {
  final TextEditingController controller;
  final DistributorCheckoutState state;

  const _CouponField({required this.controller, required this.state});

  @override
  Widget build(BuildContext context) {
    final applied = (state.couponCode ?? '').isNotEmpty;
    final cubit = context.read<DistributorCheckoutCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 66,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0x1478B943),
              border: Border.all(color: DistributorStyle.tabGreen),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/feed/coupon.svg',
                    width: 24, height: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: !applied,
                    style: DistributorStyle.style(size: 14),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter discount code'.tr(),
                      hintStyle: DistributorStyle.style(size: 14),
                    ),
                  ),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final enabled = applied || value.text.trim().isNotEmpty;
                    return GestureDetector(
                      onTap: !enabled || state.loadingSummary
                          ? null
                          : () {
                              if (applied) {
                                controller.clear();
                                cubit.applyCoupon(null);
                              } else {
                                cubit.applyCoupon(controller.text);
                              }
                            },
                      child: Container(
                        height: 29,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: enabled
                              ? DistributorStyle.green
                              : const Color(0xFFC7C7C7),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: state.loadingSummary && applied
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Text((applied ? 'Remove' : 'Apply').tr(),
                                style: DistributorStyle.style(
                                    size: 14,
                                    weight: FontWeight.w500,
                                    color: Colors.white)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if ((state.couponMessage ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
              child: Text(state.couponMessage!,
                  style: DistributorStyle.style(
                      size: 12, color: DistributorStyle.error)),
            ),
        ],
      ),
    );
  }
}

class _PaymentMethods extends StatelessWidget {
  final DistributorCheckoutState state;

  const _PaymentMethods({required this.state});

  @override
  Widget build(BuildContext context) {
    final methods = state.options?.paymentMethods ?? [];
    return _Section(
      title: 'Payment Method',
      child: methods.isEmpty
          ? Text('No payment methods available'.tr(),
              style: DistributorStyle.style(color: DistributorStyle.error))
          : Column(
              children: [
                for (final method in methods)
                  _PaymentTile(
                      method: method,
                      selected: state.paymentMethod == method.code),
              ],
            ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentMethodOption method;
  final bool selected;

  const _PaymentTile({required this.method, required this.selected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<DistributorCheckoutCubit>()
          .selectPaymentMethod(method.code!),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0x1478B833) : Colors.transparent,
          border: Border.all(
              color: selected ? DistributorStyle.green : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                selected
                    ? SvgPicture.asset('assets/svg/global/check.svg',
                        height: 22)
                    : Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFC7CAD9)),
                        ),
                      ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(method.label,
                      style: DistributorStyle.style(
                          size: 12,
                          weight: FontWeight.w500,
                          color: Colors.black)),
                ),
                if (method.isCash)
                  Image.asset('assets/images/cart/cod_hand.png', height: 25)
                else if (method.isMada)
                  Image.asset('assets/images/cart/mada_logo.png', height: 25)
                else if (method.isSadad)
                  Image.asset('assets/images/global/sadad.png', height: 20)
                else
                  const Icon(Icons.account_balance_outlined,
                      color: DistributorStyle.green),
              ],
            ),
            if (method.description.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 30, top: 4),
                child: Text(method.description,
                    style: DistributorStyle.style(
                        size: 12,
                        weight: FontWeight.w300,
                        color: DistributorStyle.textSecondary)),
              ),
            if (selected && method.isBank)
              for (final account in method.bankAccounts)
                BankAccountCard(account: account),
          ],
        ),
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  final DistributorCheckoutState state;
  final int itemCount;
  final _Estimate? estimate;

  const _Totals({required this.state, required this.itemCount, this.estimate});

  @override
  Widget build(BuildContext context) {
    final s = state.summary;
    Widget row(String title, num? value,
            {bool bold = false, bool negative = false}) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(title.tr(),
                    style: DistributorStyle.style(
                        size: 15,
                        weight: FontWeight.w300,
                        color: DistributorStyle.textSecondary)),
              ),
              if (negative) Text('- ', style: DistributorStyle.style(size: 15)),
              RiyalAmount(value,
                  size: 15, weight: bold ? FontWeight.w500 : FontWeight.w300),
            ],
          ),
        );
    const divider =
        Divider(height: 1, thickness: .25, color: DistributorStyle.muted);
    final e = estimate;
    if (e != null) {
      return _Section(
        title: 'Order Details',
        child: Column(
          children: [
            row('Total', e.items),
            divider,
            row('VAT Amount', e.vat),
            if (state.isDelivery) ...[
              divider,
              row('Delivery Fee', e.deliveryFee),
              divider,
              row('Delivery VAT Amount', e.deliveryVat),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
              child: Text(
                'Estimated amounts; the final total is calculated when the order is placed'
                    .tr(),
                style: DistributorStyle.style(
                    size: 11,
                    weight: FontWeight.w300,
                    color: DistributorStyle.textSecondary),
              ),
            ),
          ],
        ),
      );
    }
    return _Section(
      title: 'Order Details',
      child: s == null
          ? const Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                  child:
                      CircularProgressIndicator(color: DistributorStyle.green)),
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Number of Items'.tr(),
                            style: DistributorStyle.style(
                                size: 15,
                                weight: FontWeight.w300,
                                color: DistributorStyle.textSecondary)),
                      ),
                      Text(
                          '$itemCount ${(itemCount == 1 ? 'item' : 'items').tr()}',
                          style: DistributorStyle.style(size: 15)),
                    ],
                  ),
                ),
                divider,
                row('Total', s.itemsTotal),
                if (s.couponAmount > 0) ...[
                  divider,
                  row('Discount', s.couponAmount, negative: true),
                ],
                if (s.voucherDiscount > 0) ...[
                  divider,
                  row('Voucher', s.voucherDiscount, negative: true),
                ],
                divider,
                row('VAT Amount', s.vatAmount),
                if (state.isDelivery) ...[
                  divider,
                  row('Delivery Fee', s.deliveryFee),
                  if (s.deliveryCouponAmount > 0) ...[
                    divider,
                    row('Delivery discount', s.deliveryCouponAmount,
                        negative: true),
                  ],
                  divider,
                  row('Delivery VAT Amount', s.deliveryVat),
                ],
              ],
            ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final DistributorCheckoutState state;
  final _Estimate? estimate;
  final VoidCallback? onPlaceOrder;

  const _BottomBar(
      {required this.state, this.estimate, required this.onPlaceOrder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1F000000), blurRadius: 6, offset: Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        (estimate != null ? 'Estimated total' : 'Total').tr(),
                        style: DistributorStyle.style(
                            size: 15,
                            weight: FontWeight.w300,
                            color: DistributorStyle.textSecondary)),
                  ),
                  Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: RiyalAmount(
                        estimate?.total ?? state.summary?.totalWithVat,
                        size: 15,
                        weight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DistributorStyle.green,
                  disabledBackgroundColor: const Color(0xFFC7C7C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onPlaceOrder,
                child: state.placing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text('Place order'.tr(),
                        style: DistributorStyle.style(
                            size: 15, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The single product of an "Order Now" checkout.
class _DirectLine extends StatelessWidget {
  final DirectBuyItem item;

  const _DirectLine({required this.item});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'My Order',
      margin: const EdgeInsets.fromLTRB(20, 13, 20, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DistributorStyle.style()),
                  Row(
                    children: [
                      Text('${item.quantity} X ',
                          style: DistributorStyle.style(
                              weight: FontWeight.w300,
                              color: DistributorStyle.priceGrey)),
                      RiyalAmount(item.product.price,
                          weight: FontWeight.w400,
                          color: DistributorStyle.priceGrey),
                    ],
                  ),
                ],
              ),
            ),
            RiyalAmount(item.itemsTotal, size: 15, weight: FontWeight.w400),
          ],
        ),
      ),
    );
  }
}
