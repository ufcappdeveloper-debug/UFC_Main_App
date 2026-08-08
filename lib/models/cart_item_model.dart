import 'package:ufc_mobile/screens/feed/domain/entities/product/product_variant_model.dart';

class CartItemModel {
  int? id;
  int? productId;
  int? quantity;
  int? variationId;
  int? userId;
  String? remarks;
  String? createdAt;
  String? updatedAt;
  ProductVariantModel? variant;
  bool isClaimed = false;

  CartItemModel({
    this.id,
    this.productId,
    this.quantity,
    this.variationId,
    this.userId,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.variant,
    this.isClaimed = false,
  });

  CartItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isClaimed = (json['is_claimed'] == 0) ? false : true;
    productId = json['product_id'];
    quantity = json['quantity'];
    variationId = json['variation_id'];
    userId = json['user_id'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    variant = json['variant'] != null
        ? ProductVariantModel.fromJson(json['variant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['variation_id'] = variationId;
    data['user_id'] = userId;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (variant != null) {
      data['variant'] = variant!.toJson();
    }
    return data;
  }
}
