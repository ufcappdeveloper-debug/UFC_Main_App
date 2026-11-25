import 'package:ufc_mobile/global/util/common/common_utils.dart';

import 'main_source_json.dart';
import 'main_source_model.dart';

/// Business error codes of the Main Source API (plan §6).
class MainSourceErrorCode {
  static const businessModeDisabled = 'BUSINESS_MODE_DISABLED';
  static const mixedCart = 'MIXED_MAIN_SOURCE_CART';
  static const productUnavailable = 'PRODUCT_UNAVAILABLE';
  static const outOfStock = 'OUT_OF_STOCK';
  static const cartEmpty = 'CART_EMPTY';
  static const locationRequired = 'LOCATION_REQUIRED';
  static const invalidCoupon = 'INVALID_COUPON';
  static const paymentMethodDisabled = 'PAYMENT_METHOD_DISABLED';
  static const insufficientWallet = 'INSUFFICIENT_WALLET_BALANCE';
  static const sadadInfoRequired = 'SADAD_INFO_REQUIRED';
  static const sadadMinAmount = 'SADAD_MIN_AMOUNT';
  static const sadadGenerationFailed = 'SADAD_GENERATION_FAILED';
  static const paymentGatewayError = 'PAYMENT_GATEWAY_ERROR';
  static const paymentNotAllowed = 'PAYMENT_NOT_ALLOWED';
  static const orderNotCancellable = 'ORDER_NOT_CANCELLABLE';
  static const receiptNotAllowed = 'RECEIPT_NOT_ALLOWED';
  static const uploadFailed = 'UPLOAD_FAILED';

  /// Not a server code: HTTP 400 with an `errors` object.
  static const validation = 'VALIDATION';
}

/// A line of an `OUT_OF_STOCK` error at checkout (`items[]`).
class MainSourceStockIssue {
  final int? cartItemId;
  final int? variantId;
  final String? productName;
  final String? productNameAr;
  final int requestedQuantity;
  final int availableQuantity;

  /// `out_of_stock` or `unavailable`.
  final String? reason;

  const MainSourceStockIssue({
    this.cartItemId,
    this.variantId,
    this.productName,
    this.productNameAr,
    this.requestedQuantity = 0,
    this.availableQuantity = 0,
    this.reason,
  });

  factory MainSourceStockIssue.fromJson(Map<String, dynamic> json) =>
      MainSourceStockIssue(
        cartItemId: parseInt(json['cart_item_id']),
        variantId: parseInt(json['variant_id']),
        productName: parseString(json['product_name']),
        productNameAr: parseString(json['product_name_ar']),
        requestedQuantity: parseInt(json['requested_quantity']) ?? 0,
        availableQuantity: parseInt(json['available_quantity']) ?? 0,
        reason: parseString(json['reason']),
      );

  bool get isUnavailable => reason == 'unavailable';
}

/// Any failed Main Source call. Branch on [code]; [message] is English
/// and only a fallback (plan §6.1).
class MainSourceApiException implements Exception {
  final int? statusCode;
  final String? code;
  final String message;

  /// The whole error body, for the extra fields of some codes.
  final Map<String, dynamic> data;

  const MainSourceApiException({
    this.statusCode,
    this.code,
    required this.message,
    this.data = const {},
  });

  bool get isValidation => code == MainSourceErrorCode.validation;
  bool get isNotFound => statusCode == 404;
  bool get isUnauthorized => statusCode == 401;
  bool get isBusinessModeDisabled =>
      code == MainSourceErrorCode.businessModeDisabled;

  int? get availableQuantity => parseInt(data['available_quantity']);
  double? get sadadMinAmount => parseDouble(data['sadad_min_amount']);
  double? get walletBalance => parseDouble(data['wallet_balance']);
  double? get total => parseDouble(data['total']);

  /// `INVALID_COUPON`: `coupon_code` or `delivery_coupon_code`.
  String? get field => parseString(data['field']);

  /// `PAYMENT_METHOD_DISABLED`: the methods still offered.
  List<String> get paymentMethods => asStringList(data['payment_methods']);

  /// `MIXED_MAIN_SOURCE_CART`: the source already in the cart.
  MainSourceModel? get cartMainSource =>
      MainSourceModel.fromJsonOrNull(data['cart_main_source']);

  /// `OUT_OF_STOCK` at checkout lists the lines; on the cart it has
  /// [availableQuantity] instead.
  List<MainSourceStockIssue> get stockIssues =>
      asList(data['items'], MainSourceStockIssue.fromJson);

  /// Validation errors (`errors.field[0]`).
  Map<String, String> get fieldErrors {
    final errors = data['errors'];
    if (errors is! Map) return const {};
    final out = <String, String>{};
    errors.forEach((key, value) {
      final first = value is List && value.isNotEmpty ? value.first : value;
      if (first != null) out[key.toString()] = first.toString();
    });
    return out;
  }

  String? get firstFieldError => fieldErrors.values.firstOrNull;

  @override
  String toString() => message;
}
