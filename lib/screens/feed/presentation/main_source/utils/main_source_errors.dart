import 'package:easy_localization/easy_localization.dart';

import '../../../domain/entities/main_source/main_source_api_exception.dart';

/// The app's own text for an API error `code` (plan §6.1). The API
/// `message` is English and only used for codes the app doesn't know.
String mainSourceErrorText(Object error) {
  if (error is! MainSourceApiException) return error.toString();
  return mainSourceCodeText(error.code,
          availableQuantity: error.availableQuantity,
          sadadMinAmount: error.sadadMinAmount,
          hasStockItems: error.stockIssues.isNotEmpty) ??
      (error.isValidation
          ? (error.firstFieldError ?? 'Please check the highlighted fields.'.tr())
          : error.message);
}

/// Text for a known [code], or `null`.
String? mainSourceCodeText(
  String? code, {
  int? availableQuantity,
  double? sadadMinAmount,
  bool hasStockItems = false,
}) {
  switch (code) {
    case MainSourceErrorCode.businessModeDisabled:
      return 'This service is not accepting new orders at the moment.'.tr();
    case MainSourceErrorCode.mixedCart:
      return 'Your cart has products from another Main Source. Clear it and add this product?'
          .tr();
    case MainSourceErrorCode.productUnavailable:
      return 'This product is no longer available.'.tr();
    case MainSourceErrorCode.outOfStock:
      if (availableQuantity != null && !hasStockItems) {
        return 'ms_only_left_in_stock'
            .tr(namedArgs: {'available_quantity': '$availableQuantity'});
      }
      return 'Some items are not available in the requested quantity.'.tr();
    case MainSourceErrorCode.cartEmpty:
      return 'Your cart is empty.'.tr();
    case MainSourceErrorCode.locationRequired:
      return 'Choose the delivery location on the map.'.tr();
    case MainSourceErrorCode.invalidCoupon:
      return "This coupon code can't be used.".tr();
    case MainSourceErrorCode.paymentMethodDisabled:
      return 'This payment method is not available. Please choose another one.'
          .tr();
    case MainSourceErrorCode.insufficientWallet:
      return 'Your wallet balance is not enough for this order.'.tr();
    case MainSourceErrorCode.sadadInfoRequired:
      return 'Add your SADAD details to pay by SADAD.'.tr();
    case MainSourceErrorCode.sadadMinAmount:
      return 'ms_sadad_min_amount'.tr(namedArgs: {
        'sadad_min_amount': (sadadMinAmount ?? 50).toStringAsFixed(2),
      });
    case MainSourceErrorCode.sadadGenerationFailed:
      return "We couldn't create the SADAD bill. Please try again or choose another payment method."
          .tr();
    case MainSourceErrorCode.paymentGatewayError:
      return 'The payment service is not available right now. Please try again.'
          .tr();
    case MainSourceErrorCode.paymentNotAllowed:
      return "This order can't be paid online any more.".tr();
    case MainSourceErrorCode.orderNotCancellable:
      return 'This order can no longer be cancelled.'.tr();
    case MainSourceErrorCode.receiptNotAllowed:
      return "A receipt can't be uploaded for this order now.".tr();
    case MainSourceErrorCode.uploadFailed:
      return "We couldn't upload the receipt. Please try again.".tr();
  }
  return null;
}

/// Translates a `status_history[].note` (plan §5); unknown notes (the
/// customer's own cancel reason) are shown as they are.
String mainSourceHistoryNote(String note) {
  const rejectedPrefix = 'Bank transfer rejected:';
  if (note.startsWith(rejectedPrefix)) {
    final reason = note.substring(rejectedPrefix.length).trim();
    return 'ms_transfer_rejected_reason'.tr(namedArgs: {'reason': reason});
  }
  const known = {
    'Order placed',
    'Paid by wallet',
    'Payment received',
    'Payment failed',
    'Bank transfer receipt uploaded',
    'Bank transfer approved',
  };
  return known.contains(note) ? note.tr() : note;
}

/// `403 BUSINESS_MODE_DISABLED` is shown app-wide (message + back to
/// Home); screens skip their own snackbar for it.
bool mainSourceIsModeDisabled(Object? error) =>
    error is MainSourceApiException && error.isBusinessModeDisabled;
