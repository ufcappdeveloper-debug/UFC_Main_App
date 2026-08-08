import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/packing_type.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

class ProductVariantModel {
  int? id;
  int? productId;
  String? size;
  double? price;
  double? originalPrice;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;
  int? stock;
  int? sold;
  double? rating;
  int? ratingCount;
  ProductModel? product;
  PackingType? packingType;
  ProductVariantModel({
    this.id,
    this.productId,
    this.size,
    this.price,
    this.originalPrice,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
    this.stock,
    this.sold,
    this.rating,
    this.ratingCount,
    this.product,
    this.packingType,
  });

  ProductVariantModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    productId = parseInt(json['product_id']);
    size = parseString(json['size']);
    price = parseDouble(json['price']);
    originalPrice = parseDouble(json['original_price']);
    isAvailable = parseBool(json['is_available']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    stock = parseInt(json['stock']);
    sold = parseInt(json['sold']);
    rating = parseDouble(json['rating']);
    ratingCount = parseInt(json['rating_count']);
    packingType =
        json['type'] != null ? PackingType.fromJson(json['type']) : null;
    product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['size'] = size;
    data['price'] = price;
    data['original_price'] = originalPrice;
    data['is_available'] = isAvailable;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['stock'] = stock;
    data['sold'] = sold;
    data['rating'] = rating;
    data['rating_count'] = ratingCount;
    if (packingType != null) {
      data['type'] = packingType!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
