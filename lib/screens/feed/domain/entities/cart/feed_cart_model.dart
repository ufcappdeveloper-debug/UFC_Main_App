import 'package:ufc_mobile/screens/feed/domain/entities/product/product_variant_model.dart';

class FeedCartItemModel {
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

  // UI convenience fields
  String? name;
  String? unit;
  String? image;
  double? price;

  FeedCartItemModel({
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
    this.name,
    this.unit,
    this.image,
    this.price,
  });

  FeedCartItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isClaimed = (json['is_claimed'] == 0) ? false : true;
    productId = json['product_id'];
    quantity = json['quantity'];
    variationId = json['variation_id'];
    userId = json['user_id'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['variant'] != null) {
      variant = ProductVariantModel.fromJson(json['variant']);

      price = (variant?.price ?? 0).toDouble();
      name = variant?.product?.nameEn ?? "";
      image = (variant?.product?.images != null && variant!.product!.images!.isNotEmpty)
          ? variant!.product!.images!.first.location
          : null;
      unit = "pcs"; // default, can change if API provides
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['variation_id'] = variationId;
    data['user_id'] = userId;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_claimed'] = isClaimed ? 1 : 0;
    if (variant != null) {
      data['variant'] = variant!.toJson();
    }
    return data;
  }
}

class FeedCartResponseModel {
  String? message;
  List<FeedCartItemModel>? cart;
  double? totalAmount;

  FeedCartResponseModel({this.message, this.cart, this.totalAmount});

  factory FeedCartResponseModel.fromJson(Map<String, dynamic> json) {
    return FeedCartResponseModel(
      message: json['message'],
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      cart: (json['cart'] as List<dynamic>?)
          ?.map((e) => FeedCartItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'total_amount': totalAmount,
      'cart': cart?.map((e) => e.toJson()).toList(),
    };
  }
}
