import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/lang/langauge_manager.dart';
import 'package:ufc_mobile/screens/feed_old/payment/pages/mada_payment_screen.dart';

import '../../../application/main_source/main_source_order_cubit.dart';
import '../../../domain/entities/main_source/main_source_payment_models.dart';
import '../../distributor/utils/distributor_style.dart';

/// Mada for a Main Source order (plan §4.5 MADA): open the existing
/// `MadaPaymentScreen`, verify with `GET /main-source/payments/verify/{id}`
/// when it closes, and on FAILED offer "Try again" (`POST .../pay`).
/// Returns the last verify result (`null` when it could not be checked).
Future<MainSourcePaymentVerifyResult?> runMainSourceMadaPayment(
  BuildContext context,
  MainSourceOrderCubit cubit, {
  required String checkoutId,
  required String integrity,
}) async {
  var id = checkoutId;
  var hash = integrity;
  while (true) {
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (_) => MadaPaymentScreen(
        checkoutId: id,
        integrity: hash,
        languageLocale: LanguageManager.locale,
      ),
    ));
    if (!context.mounted) return null;
    final result = await LoadingDialog.show(context, cubit.verifyPayment(id));
    if (!context.mounted || result == null) return result;
    if (result.isPaid) return result;
    if (result.isPending) {
      CustomSnackBar.message(context, 'Payment is being processed');
      return result;
    }
    // FAILED
    final retry = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Payment failed'.tr(),
            style: DistributorStyle.style(size: 16, weight: FontWeight.w600)),
        content: Text('Payment was not completed. Please try again.'.tr(),
            style: DistributorStyle.style()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Try again'.tr(),
                style: const TextStyle(color: DistributorStyle.green)),
          ),
        ],
      ),
    );
    if (retry != true || !context.mounted) return result;
    final start = await LoadingDialog.show(context, cubit.startPayment());
    if (!context.mounted || start == null) return result;
    if ((start.checkoutId ?? '').isEmpty || (start.integrity ?? '').isEmpty) {
      return result;
    }
    id = start.checkoutId!;
    hash = start.integrity!;
  }
}

/// "Pay now" on the order details / success page.
Future<MainSourcePaymentVerifyResult?> payMainSourceOrderNow(
    BuildContext context, MainSourceOrderCubit cubit) async {
  final start = await LoadingDialog.show(context, cubit.startPayment());
  if (!context.mounted || start == null) return null;
  if ((start.checkoutId ?? '').isEmpty || (start.integrity ?? '').isEmpty) {
    return null;
  }
  return runMainSourceMadaPayment(context, cubit,
      checkoutId: start.checkoutId!, integrity: start.integrity!);
}
