import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../order/order_model.dart';
import 'bank_transfer_model.dart';

class DistributorPlaceOrderResult {
  final String? message;
  final OrderModel? order;

  /// Only for BANK orders: amount, reference and the accounts to transfer to.
  final BankTransferModel? bankTransfer;
  final List<int> skippedCartItemIds;

  /// MADA/CARD only: open the payment screen with these, then verify.
  final String? checkoutId;
  final String? integrity;

  const DistributorPlaceOrderResult({
    this.message,
    this.order,
    this.bankTransfer,
    this.skippedCartItemIds = const [],
    this.checkoutId,
    this.integrity,
  });

  bool get needsCardPayment =>
      (checkoutId?.isNotEmpty ?? false) && (integrity?.isNotEmpty ?? false);

  factory DistributorPlaceOrderResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    // MADA/CARD: data = { order, user, checkout_id, integrity }.
    final orderJson = data is Map<String, dynamic>
        ? (data['order'] is Map<String, dynamic> ? data['order'] : data)
        : null;
    final order = orderJson is Map<String, dynamic>
        ? OrderModel.fromJson(orderJson)
        : null;
    return DistributorPlaceOrderResult(
      message: parseString(json['message']),
      order: order,
      bankTransfer: BankTransferModel.tryParse(json['bank_transfer']) ??
          order?.bankTransfer,
      skippedCartItemIds: json['skipped_cart_item_ids'] is List
          ? (json['skipped_cart_item_ids'] as List)
              .map(parseInt)
              .whereType<int>()
              .toList()
          : const [],
      checkoutId: data is Map ? parseString(data['checkout_id']) : null,
      integrity: data is Map ? parseString(data['integrity']) : null,
    );
  }
}

class PlaceOrderAgainResult {
  final List<int> skippedVariantIds;
  const PlaceOrderAgainResult({this.skippedVariantIds = const []});
}

/// Structured error from distributor endpoints, so the UI can react to the
/// specific case (409 cart conflict, stock limits, coupon messages...).
class DistributorApiException implements Exception {
  final int? statusCode;
  final String message;
  final String? code;
  final int? variantId;
  final int? availableStock;
  final List<String> allowedPaymentMethods;

  const DistributorApiException({
    this.statusCode,
    required this.message,
    this.code,
    this.variantId,
    this.availableStock,
    this.allowedPaymentMethods = const [],
  });

  bool get isCartConflict =>
      statusCode == 409 || code == 'DISTRIBUTOR_CART_CONFLICT';
  bool get isStockLimit => availableStock != null && variantId != null;
  bool get isOutOfStockVariant =>
      message.contains('is not in Stock') && !isStockLimit;
  bool get isCouponError =>
      message.toLowerCase().contains('coupon') ||
      message.toLowerCase().contains('minimum order');
  bool get needsOptionsRefresh =>
      message.contains('does not offer') ||
      message.contains('payment method is not available') ||
      allowedPaymentMethods.isNotEmpty;

  @override
  String toString() => message;
}
