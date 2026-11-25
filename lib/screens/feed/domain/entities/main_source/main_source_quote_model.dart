import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../presentation/distributor/utils/distributor_style.dart';
import 'main_source_json.dart';
import 'main_source_model.dart';

/// An order or quote line (`items[]` of the quote and of an order).
class MainSourceOrderLine {
  final int? id;
  final int? cartItemId;
  final int? productId;
  final int? variantId;
  final String? productName;
  final String? productNameAr;
  final String? size;
  final String? image;
  final double unitPrice;
  final int quantity;
  final double total;

  const MainSourceOrderLine({
    this.id,
    this.cartItemId,
    this.productId,
    this.variantId,
    this.productName,
    this.productNameAr,
    this.size,
    this.image,
    this.unitPrice = 0,
    this.quantity = 0,
    this.total = 0,
  });

  factory MainSourceOrderLine.fromJson(Map<String, dynamic> json) =>
      MainSourceOrderLine(
        id: parseInt(json['id']),
        cartItemId: parseInt(json['cart_item_id']),
        productId: parseInt(json['product_id']),
        variantId: parseInt(json['variant_id']),
        productName: parseString(json['product_name']),
        productNameAr: parseString(json['product_name_ar']),
        size: parseString(json['size']),
        image: parseString(json['image']),
        unitPrice: money(json['unit_price']),
        quantity: parseInt(json['quantity']) ?? 0,
        total: money(json['total']),
      );

  String get name => localized(productName, productNameAr);
}

/// `POST /main-source/orders/quote` (plan §4.3).
class MainSourceQuoteModel {
  final MainSourceModel? mainSource;
  final List<MainSourceOrderLine> items;
  final double subtotal;
  final double couponAmount;
  final double vatPercentage;
  final double vatAmount;
  final double deliveryFee;
  final double deliveryCouponAmount;
  final double deliveryVat;
  final double total;
  final double totalWithVat;
  final double walletBalance;
  final double walletApplied;
  final double payableAmount;
  final List<String> paymentMethods;
  final double sadadMinAmount;

  const MainSourceQuoteModel({
    this.mainSource,
    this.items = const [],
    this.subtotal = 0,
    this.couponAmount = 0,
    this.vatPercentage = 0,
    this.vatAmount = 0,
    this.deliveryFee = 0,
    this.deliveryCouponAmount = 0,
    this.deliveryVat = 0,
    this.total = 0,
    this.totalWithVat = 0,
    this.walletBalance = 0,
    this.walletApplied = 0,
    this.payableAmount = 0,
    this.paymentMethods = const [],
    this.sadadMinAmount = 0,
  });

  factory MainSourceQuoteModel.fromJson(Map<String, dynamic> json) =>
      MainSourceQuoteModel(
        mainSource: MainSourceModel.fromJsonOrNull(json['main_source']),
        items: asList(json['items'], MainSourceOrderLine.fromJson),
        subtotal: money(json['subtotal']),
        couponAmount: money(json['coupon_amount']),
        vatPercentage: money(json['vat_percentage']),
        vatAmount: money(json['vat_amount']),
        deliveryFee: money(json['delivery_fee']),
        deliveryCouponAmount: money(json['delivery_coupon_amount']),
        deliveryVat: money(json['delivery_vat']),
        total: money(json['total']),
        totalWithVat: money(json['total_with_vat']),
        walletBalance: money(json['wallet_balance']),
        walletApplied: money(json['wallet_applied']),
        payableAmount: money(json['payable_amount']),
        paymentMethods: asStringList(json['payment_methods']),
        sadadMinAmount: money(json['sadad_min_amount']),
      );

  bool offers(String method) => paymentMethods.contains(method);

  /// Wallet checkbox: only when WALLET is offered and there is a balance.
  bool get canUseWallet =>
      offers(MainSourcePaymentMethod.wallet) && walletBalance > 0;

  /// WALLET as the main method needs the whole total.
  bool get walletCoversTotal => walletBalance >= totalWithVat;

  bool get sadadAllowed => payableAmount >= sadadMinAmount;
}
