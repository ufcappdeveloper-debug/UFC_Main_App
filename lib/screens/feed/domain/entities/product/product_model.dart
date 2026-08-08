import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_category_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_image_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_variant_model.dart';

class ProductModel {
  int? id;
  int? shopId;
  int? categoryId;
  String? nameAr;
  String? nameEn;
  String? nameUr;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionUr;
  String? productType;
  String? sku;
  String? createdAt;
  String? updatedAt;
  double? rating;
  int? ratingCount;
  String? externalRefId;
  List<ProductVariantModel>? variants;
  List<ProductImageModel>? images;
  StationModel? shop;
  CategoryModel? category;
  bool? isFavorite;
  ProductModel({
    this.id,
    this.shopId,
    this.categoryId,
    this.nameAr,
    this.nameEn,
    this.nameUr,
    this.descriptionEn,
    this.descriptionAr,
    this.descriptionUr,
    this.productType,
    this.sku,
    this.createdAt,
    this.updatedAt,
    this.rating,
    this.ratingCount,
    this.variants,
    this.images,
    this.shop,
    this.category,
    this.isFavorite,
    this.externalRefId,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    shopId = parseInt(json['shop_id']);
    categoryId = parseInt(json['category_id']);
    nameAr = parseString(json['name_ar']);
    nameEn = parseString(json['name_en']);
    nameUr = parseString(json['name_ur']);
    descriptionEn = parseString(json['description_en']);
    descriptionAr = parseString(json['description_ar']);
    descriptionUr = parseString(json['description_ur']);
    productType = parseString(json['product_type']);
    sku = parseString(json['sku']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    rating = parseDouble(json['rating']);
    ratingCount = json['rating_count'] ?? 0;
    externalRefId = parseString(json['external_ref_id']);
    if (json['variants'] != null) {
      variants = <ProductVariantModel>[];
      json['variants'].forEach((v) {
        variants!.add(ProductVariantModel.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <ProductImageModel>[];
      json['images'].forEach((v) {
        images!.add(ProductImageModel.fromJson(v));
      });
    }
    shop = json['shop'] != null ? StationModel.fromJson(json['shop']) : null;
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
    isFavorite = parseBool(json['favorite']);
  }
  bool get isInStock {
    return (variants ?? []).any((variant) => (variant.stock ?? 0) > 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['category_id'] = categoryId;
    data['name_ar'] = nameAr;
    data['name_en'] = nameEn;
    data['name_ur'] = nameUr;
    data['description_en'] = descriptionEn;
    data['description_ar'] = descriptionAr;
    data['description_ur'] = descriptionUr;
    data['product_type'] = productType;
    data['sku'] = sku;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['rating'] = rating;
    data['rating_count'] = ratingCount;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (shop != null) {
      data['shop'] = shop!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['favorite'] = isFavorite;
    return data;
  }

  ProductModel copyWith({
    int? id,
    int? shopId,
    int? categoryId,
    String? nameAr,
    String? nameEn,
    String? nameUr,
    String? descriptionEn,
    String? descriptionAr,
    String? descriptionUr,
    String? productType,
    String? sku,
    String? createdAt,
    String? updatedAt,
    double? rating,
    int? ratingCount,
    List<ProductVariantModel>? variants,
    List<ProductImageModel>? images,
    StationModel? shop,
    CategoryModel? category,
    bool? isFavorite, // add here
  }) {
    return ProductModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      categoryId: categoryId ?? this.categoryId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      nameUr: nameUr ?? this.nameUr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionUr: descriptionUr ?? this.descriptionUr,
      productType: productType ?? this.productType,
      sku: sku ?? this.sku,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      variants: variants ?? this.variants,
      images: images ?? this.images,
      shop: shop ?? this.shop,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
