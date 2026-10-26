import 'package:ufc_mobile/global/util/common/common_utils.dart';

import 'checkout_options_model.dart';

class DistributorCheckoutSummary {
  int? distributorId;
  double itemsTotal;
  double couponAmount;
  double voucherDiscount;
  double vatPercentage;
  double vatAmount;
  double deliveryFee;
  double deliveryCouponAmount;
  double deliveryVat;
  double totalWithVat;
  List<int> outOfStockVariantIds;
  Map<String, String> messages;
  CheckoutOptionsModel? checkoutOptions;

  DistributorCheckoutSummary({
    this.distributorId,
    this.itemsTotal = 0,
    this.couponAmount = 0,
    this.voucherDiscount = 0,
    this.vatPercentage = 0,
    this.vatAmount = 0,
    this.deliveryFee = 0,
    this.deliveryCouponAmount = 0,
    this.deliveryVat = 0,
    this.totalWithVat = 0,
    this.outOfStockVariantIds = const [],
    this.messages = const {},
    this.checkoutOptions,
  });

  factory DistributorCheckoutSummary.fromJson(Map<String, dynamic> json) =>
      DistributorCheckoutSummary(
        distributorId: parseInt(json['distributor_id']),
        itemsTotal: parseDouble(json['items_total']) ?? 0,
        couponAmount: parseDouble(json['coupon_amount']) ?? 0,
        voucherDiscount: parseDouble(json['voucher_discount']) ?? 0,
        vatPercentage: parseDouble(json['vat_percentage']) ?? 0,
        vatAmount: parseDouble(json['vat_amount']) ?? 0,
        deliveryFee: parseDouble(json['delivery_fee']) ?? 0,
        deliveryCouponAmount:
            parseDouble(json['delivery_coupon_amount']) ?? 0,
        deliveryVat: parseDouble(json['delivery_vat']) ?? 0,
        totalWithVat: parseDouble(json['total_with_vat']) ?? 0,
        outOfStockVariantIds: json['out_of_stock_variant_ids'] is List
            ? (json['out_of_stock_variant_ids'] as List)
                .map(parseInt)
                .whereType<int>()
                .toList()
            : [],
        messages: json['messages'] is Map
            ? (json['messages'] as Map).map(
                (k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
            : {},
        checkoutOptions:
            CheckoutOptionsModel.tryParse(json['checkout_options']),
      );
}
