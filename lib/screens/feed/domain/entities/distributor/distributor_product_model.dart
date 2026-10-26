import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../presentation/distributor/utils/distributor_style.dart';
import '../product/product_image_model.dart';

class DistributorVariantModel {
  int? id;
  double? price;
  double? originalPrice;
  int? stock;
  int? sold;
  String? size;
  bool isAvailable = true;

  DistributorVariantModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    price = parseDouble(json['price']);
    originalPrice = parseDouble(json['original_price']);
    stock = parseInt(json['stock']);
    sold = parseInt(json['sold']);
    size = parseString(json['size']);
    isAvailable = parseBool(json['is_available']) ?? true;
  }
}

/// Every distributor product has exactly one variant (`variants[0]`).
class DistributorProductModel {
  int? id;
  int? distributorId;
  int? distributorCategoryId;
  String? nameEn;
  String? nameAr;
  String? nameUr;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionUr;
  double? rating;
  int? ratingCount;
  List<ProductImageModel> images = [];
  List<DistributorVariantModel> variants = [];
  String? categoryNameEn;
  String? categoryNameAr;
  String? distributorNameEn;
  String? distributorNameAr;
  bool favorite = false;

  DistributorProductModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    distributorId = parseInt(json['distributor_id']);
    distributorCategoryId = parseInt(json['distributor_category_id']);
    nameEn = parseString(json['name_en']);
    nameAr = parseString(json['name_ar']);
    nameUr = parseString(json['name_ur']);
    descriptionEn = parseString(json['description_en']);
    descriptionAr = parseString(json['description_ar']);
    descriptionUr = parseString(json['description_ur']);
    rating = parseDouble(json['rating']);
    ratingCount = parseInt(json['rating_count']);
    if (json['images'] is List) {
      images = (json['images'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ProductImageModel.fromJson)
          .toList();
    }
    if (json['variants'] is List) {
      variants = (json['variants'] as List)
          .whereType<Map<String, dynamic>>()
          .map(DistributorVariantModel.fromJson)
          .toList();
    }
    final category = json['category'];
    if (category is Map) {
      categoryNameEn = parseString(category['name_en']);
      categoryNameAr = parseString(category['name_ar']);
    }
    final distributor = json['distributor'];
    if (distributor is Map) {
      distributorNameEn = parseString(distributor['name_en']);
      distributorNameAr = parseString(distributor['name_ar']);
      distributorId ??= parseInt(distributor['id']);
    }
    favorite = parseBool(json['favorite']) ?? false;
  }

  DistributorVariantModel? get variant => variants.firstOrNull;
  String get name => localized(nameEn, nameAr, nameUr);
  String get description =>
      localized(descriptionEn, descriptionAr, descriptionUr);
  String? get image => images.firstOrNull?.location;
  double get price => variant?.price ?? 0;
  double? get originalPrice => variant?.originalPrice;
  bool get isOffer => (originalPrice ?? 0) > price;
  int get discountPercent => isOffer
      ? (((originalPrice! - price) / originalPrice!) * 100).round()
      : 0;
  int get stock => variant?.stock ?? 0;
  bool get isOutOfStock =>
      variant == null || stock <= 0 || !variant!.isAvailable;
  String get distributorName => localized(distributorNameEn, distributorNameAr);
}
