import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

import '../../../application/authentication/auth_cubit.dart';
import '../../../application/checkout/sadad/sadad_cubit.dart';
import '../../../application/checkout/sadad/sadad_state.dart';
import '../../../application/main_source/main_source_cart_cubit.dart';
import '../../../application/main_source/main_source_checkout_cubit.dart';
import '../../../application/main_source/main_source_order_cubit.dart';
import '../../../domain/entities/checkout/sadad/sadad_user_info.dart';
import '../../../domain/entities/main_source/main_source_api_exception.dart';
import '../../../domain/entities/main_source/main_source_model.dart';
import '../../../domain/entities/main_source/main_source_params.dart';
import '../../../domain/entities/main_source/main_source_payment_models.dart';
import '../../../domain/entities/main_source/main_source_quote_model.dart';
import '../../checkout/widgets/feed_checkout_functions.dart';
import '../../distributor/utils/distributor_style.dart';
import '../../distributor/widgets/distributor_common_widgets.dart';
import '../utils/main_source_errors.dart';
import '../utils/main_source_location.dart';
import '../utils/main_source_mada_flow.dart';
import '../widgets/main_source_payment_methods.dart';
import 'main_source_location_picker.dart';
import 'main_source_order_success_page.dart';

/// Opens the checkout for the cart, or for one variant with [buyNow].
Future<void> openMainSourceCheckout(BuildContext context,
        {MainSourceBuyNow? buyNow}) =>
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => MainSourceCheckoutCubit(sl(), buyNow: buyNow)..start(),
        child: const MainSourceCheckoutPage(),
      ),
    ));

/// Main Source checkout (plan §4.1): delivery location (required; no
/// delivery-method cards, plate number or date), summary, coupon, payment,
/// note and "Place order".
class MainSourceCheckoutPage extends StatefulWidget {
  const MainSourceCheckoutPage({super.key});

  @override
  State<MainSourceCheckoutPage> createState() => _MainSourceCheckoutPageState();
}

class _MainSourceCheckoutPageState extends State<MainSourceCheckoutPage> {
  final _coupon = TextEditingController();
  final _note = TextEditingController();

  MainSourceCheckoutCubit get _cubit => context.read<MainSourceCheckoutCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _locate();
      final sadad = context.read<SadadUserInfoCubit>();
      if (sadad.state is! SadadLoaded) sadad.getUserInfo();
    });
  }

  @override
  void dispose() {
    _coupon.dispose();
    _note.dispose();
    super.dispose();
  }

  /// A fresh GPS position on every checkout; the map when it fails.
  Future<void> _locate() async {
    _cubit.setLocating(true);
    final location = await currentMainSourceLocation(context);
    if (!mounted) return;
    if (location != null) {
      _cubit.setLocation(location);
    } else {
      _cubit.setLocating(false);
      await _pickOnMap();
    }
  }

  Future<void> _pickOnMap() async {
    final picked =
        await pickMainSourceLocation(context, initial: _cubit.state.location);
    if (picked != null && mounted) _cubit.setLocation(picked);
  }

  SadadUserInfo? get _sadadInfo {
    final s = context.read<SadadUserInfoCubit>().state;
    return s is SadadLoaded ? s.userInfo : null;
  }

  /// Name and mobile are required for SADAD (plan §4.5).
  bool _hasSadadInfo(SadadUserInfo? info) =>
      (info?.customerFullName ?? '').trim().isNotEmpty &&
      (info?.customerMobileNumber ?? '').trim().isNotEmpty;

  /// The existing SADAD details dialog (`POST /sadad/save_info`).
  Future<void> _openSadadForm() => addOrEditSadadUserInfo(
      context,
      BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
      _sadadInfo);

  Future<void> _placeOrder({bool force = false}) async {
    final state = _cubit.state;
    if (state.location == null) {
      CustomSnackBar.message(
          context, mainSourceCodeText(MainSourceErrorCode.locationRequired)!);
      await _pickOnMap();
      return;
    }
    if (state.effectivePaymentMethod == null) {
      CustomSnackBar.message(
          context, 'Please select a payment method before proceeding.');
      return;
    }
    if (state.effectivePaymentMethod == MainSourcePaymentMethod.sadad &&
        !_hasSadadInfo(_sadadInfo)) {
      await _openSadadForm();
      return;
    }
    _cubit.setNote(_note.text);
    await _cubit.placeOrder(force: force);
  }

  Future<void> _onPlaced(MainSourcePlaceOrderResult result) async {
    final buyNow = _cubit.state.buyNow != null;
    // Wallet balance and cart changed.
    context.read<AuthCubit>().autoLogin();
    if (!buyNow) {
      context.read<MainSourceCartCubit>().fetchCart(silent: true);
    }
    final orderCubit =
        MainSourceOrderCubit(sl(), initial: result.order);
    if (result.payment.needsMadaPayment) {
      await runMainSourceMadaPayment(context, orderCubit,
          checkoutId: result.payment.checkoutId!,
          integrity: result.payment.integrity!);
      if (!mounted) {
        orderCubit.close();
        return;
      }
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => MainSourceOrderSuccessPage(cubit: orderCubit),
    ));
  }

  Future<void> _onStockIssue(List<MainSourceStockIssue> issues) async {
    final buyNow = _cubit.state.buyNow != null;
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            mainSourceCodeText(MainSourceErrorCode.outOfStock,
                hasStockItems: true)!,
            style: DistributorStyle.style(size: 15, weight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final i in issues)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  i.isUnavailable || i.availableQuantity <= 0
                      ? '• ${i.productName ?? ''}: ${'This product is no longer available.'.tr()}'
                      : '• ${i.productName ?? ''}: ${'ms_requested_available'.tr(namedArgs: {
                              'requested': '${i.requestedQuantity}',
                              'available': '${i.availableQuantity}',
                            })}',
                  style: DistributorStyle.style(size: 13),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('back'),
            child: Text((buyNow ? 'Back' : 'Back to cart').tr()),
          ),
          if (!buyNow)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('force'),
              child: Text('Remove unavailable items'.tr(),
                  style: const TextStyle(color: DistributorStyle.error)),
            ),
        ],
      ),
    );
    if (!mounted) return;
    if (choice == 'force') {
      await _placeOrder(force: true);
    } else if (choice == 'back') {
      if (!buyNow) context.read<MainSourceCartCubit>().fetchCart(silent: true);
      Navigator.of(context).pop();
    }
  }

  void _onError(Object error) {
    if (error is MainSourceApiException) {
      switch (error.code) {
        case MainSourceErrorCode.businessModeDisabled:
          return; // handled app-wide (message + back to Home)
        case MainSourceErrorCode.sadadInfoRequired:
          CustomSnackBar.message(context, mainSourceErrorText(error));
          _openSadadForm();
          return;
        case MainSourceErrorCode.locationRequired:
          _pickOnMap();
          return;
        case MainSourceErrorCode.insufficientWallet:
          context.read<AuthCubit>().autoLogin();
          _cubit.refreshQuote();
      }
    }
    CustomSnackBar.error(context, mainSourceErrorText(error));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainSourceCheckoutCubit, MainSourceCheckoutState>(
      listenWhen: (p, c) => p.eventId != c.eventId,
      listener: (context, state) {
        switch (state.event) {
          case MainSourceCheckoutEvent.placed:
            _onPlaced(state.result!);
          case MainSourceCheckoutEvent.stockIssue:
            _onStockIssue(state.stockIssues);
          case MainSourceCheckoutEvent.error:
            if (state.error != null) _onError(state.error!);
          case MainSourceCheckoutEvent.none:
            break;
        }
      },
      builder: (context, state) {
        final quote = state.quote;
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
              icon: const Icon(Icons.arrow_back_ios,
                  size: 16, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              _LocationCard(
                state: state,
                onChange: _pickOnMap,
                onRetryGps: _locate,
              ),
              if (quote == null && state.quoteError != null)
                CustomReloadProviderV2(
                  error: mainSourceErrorText(state.quoteError!),
                  height: 140,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  onPressed: _cubit.refreshQuote,
                )
              else if (quote == null)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                      child: CircularProgressIndicator(
                          color: DistributorStyle.green)),
                )
              else ...[
                if (state.quoteError != null)
                  _ErrorBanner(text: mainSourceErrorText(state.quoteError!)),
                _Items(quote: quote),
                _CouponField(
                  controller: _coupon,
                  applied: state.couponCode,
                  error: state.couponError == null
                      ? null
                      : mainSourceCodeText(state.couponError),
                  onApply: () => _cubit.applyCoupon(_coupon.text),
                  onRemove: () {
                    _coupon.clear();
                    _cubit.applyCoupon(null);
                  },
                ),
                MainSourcePaymentMethods(
                  quote: quote,
                  useWallet: state.useWallet,
                  selected: state.walletPaysAll
                      ? MainSourcePaymentMethod.wallet
                      : state.paymentMethod,
                  onWalletChanged: _cubit.setUseWallet,
                  onSelected: _cubit.setPaymentMethod,
                ),
                _NoteField(controller: _note, onChanged: _cubit.setNote),
                _Summary(quote: quote, quoting: state.quoting),
              ],
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DistributorStyle.green,
                    disabledBackgroundColor: DistributorStyle.muted,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: state.canPlaceOrder ? () => _placeOrder() : null,
                  child: state.placing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Place order'.tr(),
                                style: DistributorStyle.style(
                                    size: 15,
                                    weight: FontWeight.w500,
                                    color: Colors.white)),
                            if (quote != null) ...[
                              const SizedBox(width: 8),
                              RiyalAmount(quote.payableAmount,
                                  size: 14, color: Colors.white),
                            ],
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LocationCard extends StatelessWidget {
  final MainSourceCheckoutState state;
  final VoidCallback onChange;
  final VoidCallback onRetryGps;

  const _LocationCard({
    required this.state,
    required this.onChange,
    required this.onRetryGps,
  });

  @override
  Widget build(BuildContext context) {
    final location = state.location;
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      padding: const EdgeInsets.all(14),
      decoration: DistributorStyle.card(radius: 12),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined,
              color: DistributorStyle.green, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: state.locating
                ? Row(
                    children: [
                      const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: DistributorStyle.green)),
                      const SizedBox(width: 10),
                      Text('Getting your location...'.tr(),
                          style: DistributorStyle.style(size: 13)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deliver to'.tr(),
                          style: DistributorStyle.style(
                              size: 12, color: DistributorStyle.textSecondary)),
                      const SizedBox(height: 2),
                      Text(
                        location == null
                            ? 'Pick the delivery location'.tr()
                            : (location.address ??
                                '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}'),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: DistributorStyle.style(
                            size: 13,
                            weight: FontWeight.w500,
                            color: location == null
                                ? DistributorStyle.error
                                : DistributorStyle.text),
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: state.locating ? null : onChange,
            child: Text('Change on map'.tr(),
                style: DistributorStyle.style(
                    size: 12, color: DistributorStyle.green)),
          ),
        ],
      ),
    );
  }
}

class _Items extends StatelessWidget {
  final MainSourceQuoteModel quote;

  const _Items({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 8),
      padding: const EdgeInsets.all(14),
      decoration: DistributorStyle.card(radius: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (quote.mainSource != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(quote.mainSource!.name,
                  style: DistributorStyle.style(
                      size: 14, weight: FontWeight.w600)),
            ),
          for (final item in quote.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      [
                        item.name,
                        if ((item.size ?? '').isNotEmpty) '(${item.size})',
                      ].join(' '),
                      style: DistributorStyle.style(size: 13),
                    ),
                  ),
                  Text('${item.quantity} × ',
                      style: DistributorStyle.style(
                          size: 12, color: DistributorStyle.priceGrey)),
                  RiyalAmount(item.unitPrice,
                      size: 12, color: DistributorStyle.priceGrey),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CouponField extends StatelessWidget {
  final TextEditingController controller;
  final String? applied;
  final String? error;
  final VoidCallback onApply;
  final VoidCallback onRemove;

  const _CouponField({
    required this.controller,
    required this.applied,
    required this.error,
    required this.onApply,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 4, 15, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: applied == null,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Coupon code'.tr(),
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.local_offer_outlined,
                        size: 18, color: DistributorStyle.green),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: applied == null ? onApply : onRemove,
                child: Text((applied == null ? 'Apply' : 'Remove').tr(),
                    style: DistributorStyle.style(
                        size: 13,
                        color: applied == null
                            ? DistributorStyle.green
                            : DistributorStyle.error)),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(error!,
                  style: DistributorStyle.style(
                      size: 12, color: DistributorStyle.error)),
            ),
        ],
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _NoteField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLength: 1000,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Note (optional)'.tr(),
          isDense: true,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final MainSourceQuoteModel quote;
  final bool quoting;

  const _Summary({required this.quote, required this.quoting});

  @override
  Widget build(BuildContext context) {
    Widget row(String label, num value,
            {bool bold = false, bool negative = false, String? suffix}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text('${label.tr()}${suffix ?? ''}',
                    style: DistributorStyle.style(
                        size: bold ? 14 : 13,
                        weight: bold ? FontWeight.w600 : FontWeight.w400,
                        color: bold
                            ? DistributorStyle.text
                            : DistributorStyle.textSecondary)),
              ),
              if (negative)
                Text('- ', style: DistributorStyle.style(size: 13)),
              RiyalAmount(value,
                  size: bold ? 14 : 13,
                  weight: bold ? FontWeight.w600 : FontWeight.w400),
            ],
          ),
        );
    return Opacity(
      opacity: quoting ? .5 : 1,
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 4, 15, 8),
        padding: const EdgeInsets.all(14),
        decoration: DistributorStyle.card(radius: 12),
        child: Column(
          children: [
            row('Subtotal', quote.subtotal),
            if (quote.couponAmount > 0)
              row('Discount', quote.couponAmount, negative: true),
            row('VAT', quote.vatAmount,
                suffix: ' (${quote.vatPercentage.toStringAsFixed(0)}%)'),
            row('Delivery fee', quote.deliveryFee),
            if (quote.deliveryCouponAmount > 0)
              row('Delivery discount', quote.deliveryCouponAmount,
                  negative: true),
            row('Delivery VAT', quote.deliveryVat),
            const Divider(),
            row('Total', quote.totalWithVat, bold: true),
            if (quote.walletApplied > 0) ...[
              row('Paid from wallet', quote.walletApplied, negative: true),
              row('Remaining amount to be paid', quote.payableAmount,
                  bold: true),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String text;

  const _ErrorBanner({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: DistributorStyle.error.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text,
            style:
                DistributorStyle.style(size: 12, color: DistributorStyle.error)),
      );
}
