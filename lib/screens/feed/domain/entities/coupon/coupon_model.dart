// import 'package:ufc_mobile/models/product_model.dart';

// class CouponModel {
//   int? id;
//   int? productId;
//   String? couponCode;
//   double? amount;
//   bool? isPercentage;
//   int? maximumUsage;
//   double? maximumAmount;
//   double? minAmount;
//   int? usageCount;
//   int? isDelivery;
//   String? validFrom;
//   String? validTo;
//   int? userId;
//   int? shopId;
//   int? createdBy;
//   String? deletedBy;
//   String? deletedAt;
//   String? createdAt;
//   String? updatedAt;
//   int? externalRefId;
//   double? totalAmount;
//   double? redeemableAmount;
//   ProductModel? product;

//   CouponModel(
//       {this.id,
//       this.productId,
//       this.couponCode,
//       this.amount,
//       this.isPercentage,
//       this.maximumUsage,
//       this.maximumAmount,
//       this.minAmount,
//       this.usageCount,
//       this.validFrom,
//       this.validTo,
//       this.userId,
//       this.shopId,
//       this.createdBy,
//       this.deletedBy,
//       this.deletedAt,
//       this.createdAt,
//       this.updatedAt,
//       this.externalRefId,
//       this.totalAmount,
//       this.redeemableAmount,
//       this.isDelivery,
//       this.product});

//   CouponModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     isDelivery = json['is_delivery'];
//     productId = json['product_id'];
//     couponCode = json['coupon_code'];
//     amount =
//         json['amount'] == null ? 0.0 : double.parse(json['amount'].toString());
//     isPercentage = json['is_percentage'] ?? false;
//     maximumUsage = json['maximum_usage'];
//     maximumAmount = json['maximum_amount'] == null
//         ? 0.0
//         : double.parse(json['maximum_amount'].toString());
//     minAmount = json['min_amount'] == null
//         ? 0.0
//         : double.parse(json['min_amount'].toString());
//     usageCount = json['usage_count'];
//     validFrom = json['valid_from'];
//     validTo = json['valid_to'];
//     userId = json['user_id'];
//     shopId = json['shop_id'];
//     createdBy = json['created_by'];
//     deletedBy = json['deleted_by'];
//     deletedAt = json['deleted_at'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     externalRefId = json['external_ref_id'];
//     totalAmount = json['total_amount'] == null
//         ? 0.0
//         : double.parse(json['total_amount'].toString());
//     redeemableAmount = json['redeemable_amount'] == null
//         ? 0.0
//         : double.parse(json['redeemable_amount'].toString());
//     product = json['product'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['product_id'] = productId;
//     data['coupon_code'] = couponCode;
//     data['amount'] = amount;
//     data['is_percentage'] = isPercentage;
//     data['maximum_usage'] = maximumUsage;
//     data['maximum_amount'] = maximumAmount;
//     data['min_amount'] = minAmount;
//     data['usage_count'] = usageCount;
//     data['valid_from'] = validFrom;
//     data['valid_to'] = validTo;
//     data['user_id'] = userId;
//     data['shop_id'] = shopId;
//     data['created_by'] = createdBy;
//     data['deleted_by'] = deletedBy;
//     data['deleted_at'] = deletedAt;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['external_ref_id'] = externalRefId;
//     data['total_amount'] = totalAmount;
//     data['redeemable_amount'] = redeemableAmount;
//     data['product'] = product;
//     return data;
//   }
// }

import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/global/util/extension/string_extensions.dart';

class CouponModel {
  int? id;
  int? productId;
  String? couponCode;
  double? amount;
  bool? isPercentage;
  bool? isForNewUser;
  int? maximumUsage;
  double? maximumAmount;
  double? minAmount;
  int? usageCount;
  bool? isDelivery;
  String? validFrom;
  String? validTo;
  int? userId;
  int? shopId;
  int? createdBy;
  String? deletedBy;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? externalRefId;
  double? totalAmount;
  double? redeemableAmount;
  double? redeemableDeliveryAmount;
  ProductModel? product;

  CouponModel({
    this.id,
    this.productId,
    this.couponCode,
    this.amount,
    this.isPercentage,
    this.isForNewUser,
    this.maximumUsage,
    this.maximumAmount,
    this.minAmount,
    this.usageCount,
    this.validFrom,
    this.validTo,
    this.userId,
    this.shopId,
    this.createdBy,
    this.deletedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.externalRefId,
    this.totalAmount,
    this.redeemableAmount,
    this.redeemableDeliveryAmount,
    this.isDelivery,
    this.product,
  });

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    couponCode = json['coupon_code'];
    amount = json['amount']?.toString().toTryDouble() ?? 0.0;
    isPercentage = json['is_percentage'] ?? false;
    isForNewUser = json['is_for_new_user'] ?? false;
    maximumUsage = json['maximum_usage'];
    maximumAmount = json['maximum_amount']?.toString().toTryDouble() ?? 0.0;
    minAmount = json['min_amount']?.toString().toTryDouble() ?? 0.0;
    usageCount = json['usage_count'];
    validFrom = json['valid_from'];
    validTo = json['valid_to'];
    userId = json['user_id'];
    shopId = json['shop_id'];
    createdBy = json['created_by'];
    deletedBy = json['deleted_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    externalRefId = json['external_ref_id'];
    isDelivery = json['is_delivery'] == 1 || json['is_delivery'] == true;
    totalAmount = json['total_amount']?.toString().toTryDouble() ?? 0.0;
    redeemableAmount =
        json['redeemable_amount']?.toString().toTryDouble() ?? 0.0;
    redeemableDeliveryAmount =
        json['redeemable_delivery_amount']?.toString().toTryDouble() ?? 0.0;
    product =
        json['product'] == null ? null : ProductModel.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['coupon_code'] = couponCode;
    data['amount'] = amount;
    data['is_percentage'] = isPercentage;
    data['is_for_new_user'] = isForNewUser;
    data['maximum_usage'] = maximumUsage;
    data['maximum_amount'] = maximumAmount;
    data['min_amount'] = minAmount;
    data['usage_count'] = usageCount;
    data['valid_from'] = validFrom;
    data['valid_to'] = validTo;
    data['user_id'] = userId;
    data['shop_id'] = shopId;
    data['created_by'] = createdBy;
    data['deleted_by'] = deletedBy;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['external_ref_id'] = externalRefId;
    data['is_delivery'] = isDelivery;
    data['total_amount'] = totalAmount;
    data['redeemable_amount'] = redeemableAmount;
    data['redeemable_delivery_amount'] = redeemableDeliveryAmount;
    data['product'] = product?.toJson();
    return data;
  }
}
