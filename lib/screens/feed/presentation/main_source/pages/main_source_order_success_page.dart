import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/widgets/copyable_field.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';

import '../../../application/main_source/main_source_order_cubit.dart';
import '../../../domain/entities/main_source/main_source_model.dart';
import '../../../domain/entities/main_source/main_source_order_model.dart';
import '../../distributor/utils/distributor_style.dart';
import '../../distributor/widgets/distributor_common_widgets.dart';
import '../utils/main_source_errors.dart';
import '../utils/main_source_mada_flow.dart';
import '../utils/main_source_status.dart';
import '../widgets/main_source_bank_transfer_section.dart';
import 'main_source_order_details_page.dart';

/// After place order (plan §4.5): order number, payment status, SADAD
/// number + bill number, "Pay now" for an unpaid Mada order, bank accounts
/// + "Upload receipt" for BANK. [cubit] already holds the order.
class MainSourceOrderSuccessPage extends StatelessWidget {
  final MainSourceOrderCubit cubit;

  const MainSourceOrderSuccessPage({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    // The page owns the cubit (created by the checkout) and closes it.
    return BlocProvider(
      create: (_) => cubit,
      child: const _SuccessView(),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView();

  void _close(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).popUntil((r) => r.isFirst);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainSourceOrderCubit, MainSourceOrderState>(
      listenWhen: (p, c) => p.eventId != c.eventId,
      listener: (context, state) {
        if (state.event == MainSourceOrderEvent.error && state.error != null) {
          CustomSnackBar.error(context, mainSourceErrorText(state.error!));
        }
      },
      builder: (context, state) {
        final order = state.order!;
        final cubit = context.read<MainSourceOrderCubit>();
        final paid = order.isPaid;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _close(context);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => _close(context),
                ),
              ],
            ),
            body: RefreshIndicator(
              color: DistributorStyle.green,
              onRefresh: cubit.refresh,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  Icon(
                    order.paymentStatus == MainSourcePaymentStatus.failed
                        ? Icons.error_outline
                        : Icons.check_circle,
                    size: 72,
                    color: order.paymentStatus == MainSourcePaymentStatus.failed
                        ? DistributorStyle.error
                        : DistributorStyle.green,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text('Order Placed Successfully'.tr(),
                        style: DistributorStyle.style(
                            size: 18, weight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if ((order.orderNumber ?? '').isNotEmpty)
                          CopyableField(
                              label: 'Order number', value: order.orderNumber!),
                        _Row('Payment method',
                            Text(paymentMethodLabel(order.paymentMethod).tr(),
                                style: DistributorStyle.style(size: 13))),
                        _Row('Payment status',
                            Text(paymentStatusLabel(order.paymentStatus).tr(),
                                style: DistributorStyle.style(
                                    size: 13,
                                    color: paymentStatusColor(
                                        order.paymentStatus)))),
                        _Row('Total', RiyalAmount(order.totalWithVat, size: 13)),
                        if (order.walletAmountUsed > 0)
                          _Row('Paid from wallet',
                              RiyalAmount(order.walletAmountUsed, size: 13)),
                        if (!paid && order.payableAmount > 0)
                          _Row('Remaining amount to be paid',
                              RiyalAmount(order.payableAmount, size: 13)),
                      ],
                    ),
                  ),
                  if (order.paymentMethod == MainSourcePaymentMethod.cash &&
                      !paid)
                    _Hint('Pay in cash when the order is delivered.'),
                  if (order.goPay != null) MainSourceSadadBox(order: order),
                  if (order.canPay && order.isMada)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DistributorStyle.green,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23)),
                        ),
                        onPressed: state.busy == MainSourceOrderAction.pay
                            ? null
                            : () => payMainSourceOrderNow(context, cubit),
                        child: Text('Pay now'.tr()),
                      ),
                    ),
                  const MainSourceBankTransferSection(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: DistributorStyle.green,
                              side: const BorderSide(
                                  color: DistributorStyle.green),
                              minimumSize: const Size(0, 46),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23)),
                            ),
                            onPressed: order.id == null
                                ? null
                                : () => Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MainSourceOrderDetailsPage(
                                                orderId: order.id!,
                                                initial: order),
                                      ),
                                    ),
                            child: Text('View order'.tr()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DistributorStyle.green,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(0, 46),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23)),
                            ),
                            onPressed: () => _close(context),
                            child: Text('Continue shopping'.tr()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// SADAD number + bill number with copy buttons, amount and expiry.
class MainSourceSadadBox extends StatelessWidget {
  final MainSourceOrderModel order;

  const MainSourceSadadBox({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final goPay = order.goPay!;
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 12, 15, 0),
      padding: const EdgeInsets.all(14),
      decoration: DistributorStyle.card(radius: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/global/sadad.png', height: 20),
              const SizedBox(width: 8),
              Text('Pay with SADAD'.tr(),
                  style:
                      DistributorStyle.style(size: 14, weight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          if ((goPay.sadadNumber ?? '').isNotEmpty)
            CopyableField(label: 'SADAD number', value: goPay.sadadNumber!),
          if ((goPay.billNumber ?? '').isNotEmpty)
            CopyableField(label: 'Bill number', value: goPay.billNumber!),
          if (goPay.amount != null)
            _Row('Amount', RiyalAmount(goPay.amount, size: 13), padding: 0),
          if ((goPay.expireDate ?? '').isNotEmpty)
            _Row(
                'Expiry date',
                Text(goPay.expireDate!,
                    style: DistributorStyle.style(size: 13)),
                padding: 0),
          if (!order.isPaid)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                  'Pay the bill from your bank app using the SADAD number.'
                      .tr(),
                  style: DistributorStyle.style(
                      size: 11, color: DistributorStyle.textSecondary)),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final Widget value;
  final double padding;

  const _Row(this.label, this.value, {this.padding = 0});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: padding),
        child: Row(
          children: [
            Text(label.tr(),
                style: DistributorStyle.style(
                    size: 13, color: DistributorStyle.textSecondary)),
            const Spacer(),
            value,
          ],
        ),
      );
}

class _Hint extends StatelessWidget {
  final String text;

  const _Hint(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Text(text.tr(),
            style: DistributorStyle.style(
                size: 12, color: DistributorStyle.textSecondary)),
      );
}
