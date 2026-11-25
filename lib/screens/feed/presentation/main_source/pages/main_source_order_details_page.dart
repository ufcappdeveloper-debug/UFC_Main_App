import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_filex/open_filex.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/global/shared/widgets/app_image_place_holder.dart';
import 'package:ufc_mobile/global/shared/widgets/copyable_field.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';
import 'package:ufc_mobile/global/util/open_map_widget.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

import '../../../application/bottom_bar_bloc/bottom_bar_bloc.dart';
import '../../../application/main_source/main_source_cart_cubit.dart';
import '../../../application/main_source/main_source_order_cubit.dart';
import '../../../application/navbar/app_bar_cubit.dart';
import '../../../domain/entities/main_source/main_source_order_model.dart';
import '../../bottom_bar/page/feed_bottom_bar.dart';
import '../../profile/pages/feed_contact_us_page.dart';
import '../../distributor/utils/distributor_style.dart';
import '../../distributor/widgets/distributor_common_widgets.dart';
import '../utils/main_source_errors.dart';
import '../utils/main_source_mada_flow.dart';
import '../utils/main_source_push.dart';
import '../utils/main_source_status.dart';
import '../widgets/main_source_bank_transfer_section.dart';
import 'main_source_order_success_page.dart' show MainSourceSadadBox;

/// Opens an order on the root navigator (order list, push notification).
Future<void> openMainSourceOrder(BuildContext context, int orderId) =>
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (_) => MainSourceOrderDetailsPage(orderId: orderId),
    ));

/// Order details (plan §5): items, totals, delivery location, timeline,
/// SADAD info, bank transfer, Cancel / Pay now / Upload receipt / Order
/// again.
class MainSourceOrderDetailsPage extends StatelessWidget {
  final int orderId;
  final MainSourceOrderModel? initial;

  const MainSourceOrderDetailsPage(
      {super.key, required this.orderId, this.initial});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainSourceOrderCubit(sl(), initial: initial)
        ..load(orderId, silent: initial != null),
      child: const _DetailsView(),
    );
  }
}

class _DetailsView extends StatefulWidget {
  const _DetailsView();

  @override
  State<_DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<_DetailsView>
    with WidgetsBindingObserver {
  StreamSubscription<int>? _push;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // "Payment Confirmed", status changes...: reload this order.
    final cubit = context.read<MainSourceOrderCubit>();
    _push = MainSourcePush.received.listen((id) {
      if (id == cubit.state.order?.id) cubit.refresh();
    });
  }

  @override
  void dispose() {
    _push?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Payment may have been confirmed while the app was in the background.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<MainSourceOrderCubit>().refresh();
    }
  }

  Future<void> _cancel(MainSourceOrderModel order) async {
    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancel order'.tr(),
            style: DistributorStyle.style(size: 16, weight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel this order?'.tr(),
                style: DistributorStyle.style()),
            // Money already transferred is refunded outside the app.
            if (order.bankTransfer != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                    'You already uploaded a transfer receipt. UFC will contact you about the refund.'
                        .tr(),
                    style: DistributorStyle.style(
                        size: 12, color: DistributorStyle.error)),
              ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonCtrl,
              maxLength: 255,
              decoration: InputDecoration(
                hintText: 'Reason (optional)'.tr(),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Back'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Cancel order'.tr(),
                style: const TextStyle(color: DistributorStyle.error)),
          ),
        ],
      ),
    );
    final reason = reasonCtrl.text;
    reasonCtrl.dispose();
    if (ok == true && mounted) {
      await context.read<MainSourceOrderCubit>().cancel(reason: reason);
    }
  }

  Future<void> _openInvoice(MainSourceOrderCubit cubit) async {
    final path = await cubit.downloadInvoice();
    if (path != null) await OpenFilex.open(path);
  }

  /// Fills the cart with the items still sold, then opens the Cart tab.
  Future<void> _orderAgain(MainSourceOrderModel order) async {
    if (order.id == null) return;
    final bottomNav = context.read<FeedBottomNavCubit>();
    final appBarHeight = context.read<AppBarHeightCubit>();
    final background = context.read<FeedBackgroundCubit>();
    final appBar = context.read<AppBarCubit>();
    final navigator = Navigator.of(context, rootNavigator: true);
    try {
      final result =
          await context.read<MainSourceCartCubit>().reorder(order.id!);
      if (!mounted) return;
      if (result.skippedItems.isNotEmpty) {
        CustomSnackBar.message(context, 'Some items are no longer available');
      } else {
        CustomSnackBar.success(context, 'Items added to cart');
      }
    } catch (e) {
      if (mounted && !(mainSourceIsModeDisabled(e))) {
        CustomSnackBar.error(context, mainSourceErrorText(e));
      }
      return;
    }
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => BottomBar(initialIndex: 0)),
      (route) => false,
    );
    bottomNav.changeTab(2);
    appBarHeight.setHeight(31);
    background.updateBackground(AppImages.feedSmallBg);
    appBar.setMode(AppBarMode.channel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainSourceOrderCubit, MainSourceOrderState>(
      listenWhen: (p, c) => p.eventId != c.eventId,
      listener: (context, state) {
        switch (state.event) {
          case MainSourceOrderEvent.cancelled:
            CustomSnackBar.success(context, 'Order cancelled');
          case MainSourceOrderEvent.error:
            if (state.error != null && !mainSourceIsModeDisabled(state.error)) {
              CustomSnackBar.error(context, mainSourceErrorText(state.error!));
            }
          case MainSourceOrderEvent.uploaded:
          case MainSourceOrderEvent.none:
            break;
        }
      },
      builder: (context, state) {
        final order = state.order;
        final cubit = context.read<MainSourceOrderCubit>();
        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text('Order details'.tr(),
                style:
                    DistributorStyle.style(size: 15, weight: FontWeight.w500)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  size: 16, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                onPressed: () => push(context, FeedContactPage()),
                icon: SvgPicture.asset('assets/svg/feed/message.svg',
                    height: 24, width: 24),
              ),
            ],
          ),
          body: order == null
              ? (state.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: DistributorStyle.green))
                  : CustomReloadProviderV2(
                      error: state.loadError == null
                          ? null
                          : mainSourceErrorText(state.loadError!),
                      height: 160,
                      decoration:
                          const BoxDecoration(color: Colors.transparent),
                      onPressed: () {
                        final page = context.findAncestorWidgetOfExactType<
                            MainSourceOrderDetailsPage>();
                        if (page != null) cubit.load(page.orderId);
                      },
                    ))
              : RefreshIndicator(
                  color: DistributorStyle.green,
                  onRefresh: cubit.refresh,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      _Header(order: order),
                      _Timeline(order: order),
                      if (order.delivery != null)
                        _DeliveryCard(delivery: order.delivery!),
                      _ItemsCard(order: order),
                      _TotalsCard(order: order),
                      if (order.goPay != null) MainSourceSadadBox(order: order),
                      if (order.canPay && order.isMada)
                        _ActionButton(
                          label: 'Pay now',
                          busy: state.busy == MainSourceOrderAction.pay,
                          onTap: () => payMainSourceOrderNow(context, cubit),
                        ),
                      const MainSourceBankTransferSection(),
                      if ((order.note ?? '').isNotEmpty)
                        _Card(
                          title: 'Note',
                          child: Text(order.note!,
                              style: DistributorStyle.style(size: 13)),
                        ),
                      // Same PDF invoice as station / distributor orders.
                      _ActionButton(
                        label: 'Order Details',
                        busy: state.busy == MainSourceOrderAction.invoice,
                        onTap: () => _openInvoice(cubit),
                      ),
                      _ActionButton(
                        label: 'Order again',
                        outlined: true,
                        onTap: () => _orderAgain(order),
                      ),
                      if (order.canCancel)
                        _ActionButton(
                          label: 'Cancel order',
                          danger: true,
                          busy: state.busy == MainSourceOrderAction.cancel,
                          onTap: () => _cancel(order),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  final String? title;
  final Widget child;

  const _Card({this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(15, 8, 15, 0),
        padding: const EdgeInsets.all(14),
        decoration: DistributorStyle.card(radius: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!.tr(),
                  style: DistributorStyle.style(
                      size: 14, weight: FontWeight.w600)),
              const SizedBox(height: 8),
            ],
            child,
          ],
        ),
      );
}

class _Header extends StatelessWidget {
  final MainSourceOrderModel order;

  const _Header({required this.order});

  @override
  Widget build(BuildContext context) {
    final created = order.createdAt;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(order.mainSource?.name ?? '',
                    style: DistributorStyle.style(
                        size: 14, weight: FontWeight.w600)),
              ),
              OutlineChip(
                  label: orderStatusLabel(order.orderStatus),
                  color: orderStatusColor(order.orderStatus)),
            ],
          ),
          if ((order.orderNumber ?? '').isNotEmpty)
            CopyableField(label: 'Order number', value: order.orderNumber!),
          if (created != null)
            Text(
                DateFormat('yyyy-MM-dd  HH:mm', context.locale.languageCode)
                    .format(created),
                style: DistributorStyle.style(
                    size: 12, color: DistributorStyle.textSecondary)),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final MainSourceOrderModel order;

  const _Timeline({required this.order});

  @override
  Widget build(BuildContext context) {
    final history = order.statusHistory;
    if (history.isEmpty) return const SizedBox.shrink();
    return _Card(
      title: 'Order status',
      child: Column(
        children: [
          for (var i = 0; i < history.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(Icons.circle,
                        size: 12,
                        color: i == history.length - 1
                            ? DistributorStyle.green
                            : DistributorStyle.muted),
                    if (i < history.length - 1)
                      Container(
                          width: 2, height: 34, color: DistributorStyle.muted),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // Payment events keep the status: show the note.
                          history[i].isPaymentEvent &&
                                  (history[i].note ?? '').isNotEmpty
                              ? mainSourceHistoryNote(history[i].note!)
                              : orderStatusLabel(history[i].toStatus).tr(),
                          style: DistributorStyle.style(
                              size: 13, weight: FontWeight.w500),
                        ),
                        if (!history[i].isPaymentEvent &&
                            (history[i].note ?? '').isNotEmpty)
                          Text(mainSourceHistoryNote(history[i].note!),
                              style: DistributorStyle.style(
                                  size: 12,
                                  color: DistributorStyle.textSecondary)),
                        if (history[i].createdAt != null)
                          Text(
                              DateFormat('yyyy-MM-dd  HH:mm',
                                      context.locale.languageCode)
                                  .format(history[i].createdAt!),
                              style: DistributorStyle.style(
                                  size: 11, color: DistributorStyle.muted)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final MainSourceDelivery delivery;

  const _DeliveryCard({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Delivery location',
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined,
              color: DistributorStyle.green),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  delivery.address ??
                      '${delivery.latitude?.toStringAsFixed(5)}, ${delivery.longitude?.toStringAsFixed(5)}',
                  style: DistributorStyle.style(size: 13),
                ),
                if ((delivery.landmark ?? '').isNotEmpty)
                  Text(delivery.landmark!,
                      style: DistributorStyle.style(
                          size: 12, color: DistributorStyle.textSecondary)),
              ],
            ),
          ),
          if (delivery.hasCoordinates)
            TextButton(
              onPressed: () => openMapsAt(context,
                  latitude: delivery.latitude!,
                  longitude: delivery.longitude!,
                  title: delivery.address ?? ''),
              child: Text('Open in Maps'.tr(),
                  style: DistributorStyle.style(
                      size: 12, color: DistributorStyle.green)),
            ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final MainSourceOrderModel order;

  const _ItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Items',
      child: Column(
        children: [
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageWithPlaceHolder(
                        imageUrl: item.image,
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: DistributorStyle.style(size: 13)),
                        Text(
                            [
                              if ((item.size ?? '').isNotEmpty) item.size!,
                              '${item.quantity} ×',
                            ].join('  '),
                            style: DistributorStyle.style(
                                size: 12, color: DistributorStyle.priceGrey)),
                      ],
                    ),
                  ),
                  RiyalAmount(item.total, size: 13),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  final MainSourceOrderModel order;

  const _TotalsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    Widget row(String label, num value,
            {bool bold = false, bool negative = false}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Expanded(
                child: Text(label.tr(),
                    style: DistributorStyle.style(
                        size: 13,
                        weight: bold ? FontWeight.w600 : FontWeight.w400,
                        color: bold
                            ? DistributorStyle.text
                            : DistributorStyle.textSecondary)),
              ),
              if (negative) Text('- ', style: DistributorStyle.style()),
              RiyalAmount(value,
                  size: 13, weight: bold ? FontWeight.w600 : FontWeight.w400),
            ],
          ),
        );
    return _Card(
      title: 'Payment',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(paymentMethodLabel(order.paymentMethod).tr(),
                      style: DistributorStyle.style(size: 13)),
                ),
                Text(paymentStatusLabel(order.paymentStatus).tr(),
                    style: DistributorStyle.style(
                        size: 13,
                        color: paymentStatusColor(order.paymentStatus))),
              ],
            ),
          ),
          row('Subtotal', order.subtotal),
          if (order.couponAmount > 0)
            row('Discount', order.couponAmount, negative: true),
          row('VAT', order.vatAmount),
          row('Delivery fee', order.deliveryFee),
          if (order.deliveryCouponAmount > 0)
            row('Delivery discount', order.deliveryCouponAmount,
                negative: true),
          row('Delivery VAT', order.deliveryVat),
          const Divider(),
          row('Total', order.totalWithVat, bold: true),
          if (order.walletAmountUsed > 0)
            row('Paid from wallet', order.walletAmountUsed, negative: true),
          if (order.walletAmountUsed > 0 || !order.isPaid)
            row('Remaining amount to be paid', order.payableAmount, bold: true),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool busy;
  final bool outlined;
  final bool danger;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.busy = false,
    this.outlined = false,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? DistributorStyle.error : DistributorStyle.green;
    final child = busy
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                strokeWidth: 2,
                color: outlined || danger ? color : Colors.white))
        : Text(label.tr());
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(23));
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: outlined || danger
            ? OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                    shape: shape),
                onPressed: busy ? null : onTap,
                child: child,
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: shape),
                onPressed: busy ? null : onTap,
                child: child,
              ),
      ),
    );
  }
}
