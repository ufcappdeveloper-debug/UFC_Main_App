import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../presentation/distributor/utils/distributor_style.dart';

/// Distributor categories are flat (`category.name_en`), unlike shop
/// categories which are wrapped (`item.category.name_en`).
class DistributorCategoryModel {
  int? id;
  int? distributorId;
  String? nameEn;
  String? nameAr;
  String? nameUr;
  String? image;
  String? icon;
  int? sortOrder;
  int? productsCount;

  DistributorCategoryModel({this.id, this.nameEn, this.nameAr});

  DistributorCategoryModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    distributorId = parseInt(json['distributor_id']);
    nameEn = parseString(json['name_en']);
    nameAr = parseString(json['name_ar']);
    nameUr = parseString(json['name_ur']);
    image = parseString(json['image']);
    icon = parseString(json['icon']);
    sortOrder = parseInt(json['sort_order']);
    productsCount = parseInt(json['products_count']);
  }

  String get name => localized(nameEn, nameAr, nameUr);
}
