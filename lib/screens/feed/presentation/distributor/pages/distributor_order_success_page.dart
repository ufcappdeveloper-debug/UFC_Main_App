import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/global/extensions/app_images.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/bank_account_card.dart';
import 'package:ufc_mobile/global/shared/widgets/copyable_field.dart';
import 'package:ufc_mobile/global/util/product/product_util.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';

import '../../../application/bottom_bar_bloc/bottom_bar_bloc.dart';
import '../../../application/navbar/app_bar_cubit.dart';
import '../../../domain/entities/distributor/checkout_options_model.dart';
import '../../../domain/entities/distributor/distributor_place_order_result.dart';
import '../../bottom_bar/page/feed_bottom_bar.dart';
import '../../profile/pages/feed_order_details.dart';
import '../utils/distributor_style.dart';
import '../widgets/bank_receipt_section.dart';
import '../widgets/distributor_common_widgets.dart';

/// Shown after a distributor order is placed. Built from the place_order
/// response; BANK orders get the bank transfer box with copy buttons.
class DistributorOrderSuccessPage extends StatefulWidget {
  final DistributorPlaceOrderResult result;

  const DistributorOrderSuccessPage({super.key, required this.result});

  @override
  State<DistributorOrderSuccessPage> createState() =>
      _DistributorOrderSuccessPageState();
}

class _DistributorOrderSuccessPageState
    extends State<DistributorOrderSuccessPage> {
  bool _receiptUploaded = false;

  DistributorPlaceOrderResult get result => widget.result;

  void _home(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => BottomBar(initialIndex: 0)),
      (route) => false,
    );
    context.read<FeedBottomNavCubit>().changeTab(0);
    context.read<FeedBackgroundCubit>().updateBackground(AppImages.feedBg);
    context.read<AppBarCubit>().setMode(AppBarMode.normal);
  }

  @override
  Widget build(BuildContext context) {
    final order = result.order;
    final items = order?.orderItems ?? [];
    final isPickup = order?.orderType == DistributorOrderType.pickup;
    final isBank = order?.paymentMethod == DistributorPaymentMethod.bank;
    final paid = order?.paymentStatus == 'PAID';
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _home(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Colors.black),
            onPressed: () => _home(context),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            const SizedBox(height: 20),
            Center(
              child: SvgPicture.asset('assets/svg/feed/success.svg',
                  width: 82, height: 82),
            ),
            const SizedBox(height: 30),
            Text(
              'Your order has been processed successfully'.tr(),
              textAlign: TextAlign.center,
              style: DistributorStyle.style(
                  size: 23,
                  weight: FontWeight.w500,
                  color: const Color(0xFF1E3354)),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              padding: const EdgeInsets.all(10),
              decoration: DistributorStyle.card(radius: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Order Status'.tr(),
                        style: DistributorStyle.style(
                            size: 15, weight: FontWeight.w500)),
                  ),
                  _row('Order Number', Text('#${order?.id ?? ''}')),
                  if ((order?.vendorName ?? '').isNotEmpty)
                    _row('Distributor', Text(order!.vendorName)),
                  _divider,
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ordered Products'.tr(),
                            style: DistributorStyle.style(size: 16)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (final item in items)
                                Text(
                                  '${ProductUtils.productName(item.displayProduct)}  x${item.quantity ?? 0}',
                                  textAlign: TextAlign.end,
                                  style: DistributorStyle.style(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _divider,
                  _row('Total', RiyalAmount(order?.totalWithVat,
                      size: 15, weight: FontWeight.w300)),
                  _divider,
                  _row(
                      'Delivery Method',
                      Text((isPickup
                              ? "Pick up from distributor's location"
                              : 'Home delivery')
                          .tr())),
                  _divider,
                  _row(
                    'Payment Method',
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _paymentIcon(order?.paymentMethod),
                        const SizedBox(width: 6),
                        Text(_paymentLabel(order?.paymentMethod).tr()),
                      ],
                    ),
                  ),
                  // SADAD: the bill number to pay with.
                  if ((order?.goPay?.billNumber ?? '').isNotEmpty) ...[
                    _divider,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CopyableField(
                          label: 'Bill Number',
                          value: order!.goPay!.billNumber!),
                    ),
                  ],
                  if (isBank && !paid)
                    _row(
                      'Payment status',
                      Text('Pending'.tr(),
                          style: DistributorStyle.style(
                              color: const Color(0xFFE0A800))),
                    ),
                ],
              ),
            ),
            if (result.skippedCartItemIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Some unavailable items were not included in this order'.tr(),
                  style: DistributorStyle.style(
                      size: 12, color: DistributorStyle.error),
                ),
              ),
            if (result.bankTransfer != null && !paid)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: BankTransferBox(transfer: result.bankTransfer!),
              ),
            // The order already exists: a failed upload can simply be retried
            // here or later from My Orders, never by placing the order again.
            if (result.bankTransfer != null && !paid && order?.id != null)
              BankReceiptSection(
                orderId: order!.id!,
                receiptUrl: order.bankReceiptUrl,
                uploadedAt: order.bankReceiptUploadedAt,
                onChanged: () => setState(() => _receiptUploaded = true),
              ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 287,
                height: 42,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DistributorStyle.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  onPressed: order == null
                      ? null
                      : () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FeedOrderDetails(order: order))),
                  child: Text('Track my Order'.tr(),
                      style: DistributorStyle.style(
                          size: 15,
                          weight: FontWeight.w500,
                          color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 287,
                height: 42,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DistributorStyle.green,
                    side: const BorderSide(color: DistributorStyle.green),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  onPressed: () => _home(context),
                  child: Text(
                      (result.bankTransfer != null &&
                                  !paid &&
                                  !_receiptUploaded
                              ? 'later'
                              : 'Back to Home')
                          .tr(),
                      style: DistributorStyle.style(
                          size: 15,
                          weight: FontWeight.w500,
                          color: DistributorStyle.green)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _paymentLabel(String? method) {
    switch (method) {
      case DistributorPaymentMethod.bank:
        return 'Bank transfer';
      case DistributorPaymentMethod.cash:
        return 'Cash';
      default:
        return method ?? '';
    }
  }

  static Widget _paymentIcon(String? method) {
    switch (method) {
      case DistributorPaymentMethod.bank:
        return const Icon(Icons.account_balance_outlined,
            size: 18, color: DistributorStyle.green);
      case 'MADA':
      case 'CARD':
        return Image.asset('assets/images/cart/mada_logo.png', height: 20);
      case 'SADAD':
        return Image.asset('assets/images/global/sadad.png', height: 20);
      default:
        return Image.asset('assets/images/cart/cod_hand.png', height: 20);
    }
  }

  static const _divider =
      Divider(height: 12, thickness: .5, color: Color(0xFFE0E0E0));

  Widget _row(String title, Widget value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
                child: Text(title.tr(), style: DistributorStyle.style(size: 15))),
            DefaultTextStyle(
                style: DistributorStyle.style(size: 14), child: value),
          ],
        ),
      );
}
