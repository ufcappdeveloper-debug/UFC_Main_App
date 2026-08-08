import 'package:collection/collection.dart';

import 'image.dart';

class Product {
  int? id;
  int? shopId;
  int? categoryId;
  dynamic nameAr;
  String? nameEn;
  dynamic descriptionEn;
  dynamic descriptionAr;
  dynamic productType;
  dynamic sku;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? rating;
  int? ratingCount;
  List<Image>? images;
  dynamic category;

  Product({
    this.id,
    this.shopId,
    this.categoryId,
    this.nameAr,
    this.nameEn,
    this.descriptionEn,
    this.descriptionAr,
    this.productType,
    this.sku,
    this.createdAt,
    this.updatedAt,
    this.rating,
    this.ratingCount,
    this.images,
    this.category,
  });

  @override
  String toString() {
    return 'Product(id: $id, shopId: $shopId, categoryId: $categoryId, nameAr: $nameAr, nameEn: $nameEn, descriptionEn: $descriptionEn, descriptionAr: $descriptionAr, productType: $productType, sku: $sku, createdAt: $createdAt, updatedAt: $updatedAt, rating: $rating, ratingCount: $ratingCount, images: $images, category: $category)';
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        shopId: json['shop_id'] as int?,
        categoryId: json['category_id'] as int?,
        nameAr: json['name_ar'] as dynamic,
        nameEn: json['name_en'] as String?,
        descriptionEn: json['description_en'] as dynamic,
        descriptionAr: json['description_ar'] as dynamic,
        productType: json['product_type'] as dynamic,
        sku: json['sku'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        rating: json['rating'] as int?,
        ratingCount: json['rating_count'] as int?,
        images: (json['images'] as List<dynamic>?)
            ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
            .toList(),
        category: json['category'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'shop_id': shopId,
        'category_id': categoryId,
        'name_ar': nameAr,
        'name_en': nameEn,
        'description_en': descriptionEn,
        'description_ar': descriptionAr,
        'product_type': productType,
        'sku': sku,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'rating': rating,
        'rating_count': ratingCount,
        'images': images?.map((e) => e.toJson()).toList(),
        'category': category,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Product) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      shopId.hashCode ^
      categoryId.hashCode ^
      nameAr.hashCode ^
      nameEn.hashCode ^
      descriptionEn.hashCode ^
      descriptionAr.hashCode ^
      productType.hashCode ^
      sku.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      rating.hashCode ^
      ratingCount.hashCode ^
      images.hashCode ^
      category.hashCode;
}
