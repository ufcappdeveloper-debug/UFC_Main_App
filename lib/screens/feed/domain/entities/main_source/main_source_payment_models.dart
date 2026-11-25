import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../distributor/bank_account_model.dart';
import 'main_source_cart_model.dart';
import 'main_source_json.dart';
import 'main_source_model.dart';
import 'main_source_order_model.dart';

/// `data.payment` of `POST /main-source/orders` (plan §4.4 / §4.5).
class MainSourcePaymentInfo {
  final String? method;
  final String? checkoutId;
  final String? integrity;
  final MainSourceGoPay? goPay;
  final List<BankAccountModel> bankAccounts;

  const MainSourcePaymentInfo({
    this.method,
    this.checkoutId,
    this.integrity,
    this.goPay,
    this.bankAccounts = const [],
  });

  factory MainSourcePaymentInfo.fromJson(Map<String, dynamic> json) =>
      MainSourcePaymentInfo(
        method: parseString(json['method']),
        checkoutId: parseString(json['checkout_id']),
        integrity: parseString(json['integrity']),
        goPay: MainSourceGoPay.fromJsonOrNull(json['go_pay']),
        bankAccounts: BankAccountModel.listFromJson(json['bank_accounts']),
      );

  bool get needsMadaPayment =>
      method == MainSourcePaymentMethod.mada &&
      (checkoutId?.isNotEmpty ?? false) &&
      (integrity?.isNotEmpty ?? false);
}

class MainSourcePlaceOrderResult {
  final MainSourceOrderModel order;
  final MainSourcePaymentInfo payment;

  const MainSourcePlaceOrderResult({
    required this.order,
    required this.payment,
  });

  factory MainSourcePlaceOrderResult.fromJson(Map<String, dynamic> data) =>
      MainSourcePlaceOrderResult(
        order: MainSourceOrderModel.fromJson(asMap(data['order'])),
        payment: MainSourcePaymentInfo.fromJson(asMap(data['payment'])),
      );
}

/// `GET /main-source/payments/verify/{checkoutId}`.
class MainSourcePaymentVerifyResult {
  final String? paymentStatus;
  final int? orderId;
  final String? orderNumber;
  final String? orderPaymentStatus;

  const MainSourcePaymentVerifyResult({
    this.paymentStatus,
    this.orderId,
    this.orderNumber,
    this.orderPaymentStatus,
  });

  factory MainSourcePaymentVerifyResult.fromJson(Map<String, dynamic> json) =>
      MainSourcePaymentVerifyResult(
        paymentStatus: parseString(json['payment_status']),
        orderId: parseInt(json['order_id']),
        orderNumber: parseString(json['order_number']),
        orderPaymentStatus: parseString(json['order_payment_status']),
      );

  bool get isPaid => paymentStatus == MainSourcePaymentStatus.paid;
  bool get isPending => paymentStatus == MainSourcePaymentStatus.pending;
  bool get isFailed => paymentStatus == MainSourcePaymentStatus.failed;
}

/// `POST /main-source/orders/{id}/pay`: a new Mada checkout.
class MainSourcePayStartResult {
  final int? orderId;
  final String? orderNumber;
  final String? method;
  final String? checkoutId;
  final String? integrity;

  const MainSourcePayStartResult({
    this.orderId,
    this.orderNumber,
    this.method,
    this.checkoutId,
    this.integrity,
  });

  factory MainSourcePayStartResult.fromJson(Map<String, dynamic> json) =>
      MainSourcePayStartResult(
        orderId: parseInt(json['order_id']),
        orderNumber: parseString(json['order_number']),
        method: parseString(json['method']),
        checkoutId: parseString(json['checkout_id']),
        integrity: parseString(json['integrity']),
      );
}

/// `POST /main-source/orders/{id}/reorder`.
class MainSourceReorderResult {
  final MainSourceCartModel cart;
  final List<String> skippedItems;
  final String? message;

  const MainSourceReorderResult({
    required this.cart,
    this.skippedItems = const [],
    this.message,
  });

  factory MainSourceReorderResult.fromJson(Map<String, dynamic> data,
          {String? message}) =>
      MainSourceReorderResult(
        cart: MainSourceCartModel.fromJson(asMap(data['cart'])),
        skippedItems: asStringList(data['skipped_items']),
        message: message,
      );
}
