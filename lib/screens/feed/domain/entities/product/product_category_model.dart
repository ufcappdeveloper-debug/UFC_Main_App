import 'package:ufc_mobile/global/util/common/common_utils.dart';

class CategoryModel {
  int? id;
  int? shopId;
  String? nameEn;
  String? nameAr;
  String? nameUr;
  String? image;
  String? icon;
  String? descriptionEn;
  String? descriptionAr;
  bool? isActive;
  bool? isFeatured;
  bool? isPopular;
  bool? isTrending;
  bool? isNew;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? sortOrder;
  String? externalRefId;
  CategoryModel({
    this.id,
    this.shopId,
    this.nameEn,
    this.nameAr,
    this.nameUr,
    this.image,
    this.icon,
    this.descriptionEn,
    this.descriptionAr,
    this.isActive,
    this.isFeatured,
    this.isPopular,
    this.isTrending,
    this.isNew,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.sortOrder,
    this.externalRefId,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    shopId = parseInt(json['shop_id']);
    nameEn = parseString(json['name_en']);
    nameAr = parseString(json['name_ar']);
    nameUr = parseString(json['name_ur']);
    image = parseString(json['image']);
    icon = parseString(json['icon']);
    descriptionEn = (json['description_en']);
    descriptionAr = (json['description_ar']);
    isActive = parseBool(json['is_active']);
    isFeatured = parseBool(json['is_featured']);
    isPopular = parseBool(json['is_popular']);
    isTrending = parseBool(json['is_trending']);
    isNew = parseBool(json['is_new']);
    deletedAt = parseString(json['deleted_at']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    sortOrder = parseString(json['sort_order']);
    externalRefId = parseString(json['external_ref_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['name_en'] = nameEn;
    data['name_ar'] = nameAr;
    data['name_ur'] = nameUr;
    data['image'] = image;
    data['icon'] = icon;
    data['description_en'] = descriptionEn;
    data['description_ar'] = descriptionAr;
    data['is_active'] = isActive;
    data['is_featured'] = isFeatured;
    data['is_popular'] = isPopular;
    data['is_trending'] = isTrending;
    data['is_new'] = isNew;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['sort_order'] = sortOrder;
    data['external_ref_id'] = externalRefId;
    return data;
  }
}
