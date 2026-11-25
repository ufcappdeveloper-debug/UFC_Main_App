import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../presentation/distributor/utils/distributor_style.dart';
import 'main_source_json.dart';

/// Payment method codes used by Main Source (plan §0 Conventions).
class MainSourcePaymentMethod {
  static const cash = 'CASH';
  static const sadad = 'SADAD';
  static const mada = 'MADA';
  static const wallet = 'WALLET';
  static const bank = 'BANK';
}

/// A Main Source. The full object comes from `/main-source/home`,
/// `/main-sources` and `/app/business-config`; carts, products and orders
/// embed a short version (id, names, icon, sometimes phone).
class MainSourceModel {
  final int? id;
  final String? nameEn;
  final String? nameAr;
  final String? nameUr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? icon;
  final String? photo;
  final String? phone;
  final String? email;
  final double? deliveryFee;
  final bool supportsDelivery;
  final bool supportsPickup;
  final List<String> paymentMethods;
  final List<MainSourceCategoryModel> categories;

  const MainSourceModel({
    this.id,
    this.nameEn,
    this.nameAr,
    this.nameUr,
    this.descriptionEn,
    this.descriptionAr,
    this.icon,
    this.photo,
    this.phone,
    this.email,
    this.deliveryFee,
    this.supportsDelivery = true,
    this.supportsPickup = false,
    this.paymentMethods = const [],
    this.categories = const [],
  });

  factory MainSourceModel.fromJson(Map<String, dynamic> json) =>
      MainSourceModel(
        id: parseInt(json['id']),
        nameEn: parseString(json['name_en']),
        nameAr: parseString(json['name_ar']),
        nameUr: parseString(json['name_ur']),
        descriptionEn: parseString(json['description_en']),
        descriptionAr: parseString(json['description_ar']),
        icon: parseString(json['icon']),
        photo: parseString(json['photo']),
        phone: parseString(json['phone']),
        email: parseString(json['email']),
        deliveryFee: parseDouble(json['delivery_fee']),
        supportsDelivery: parseBool(json['supports_delivery']) ?? true,
        supportsPickup: parseBool(json['supports_pickup']) ?? false,
        paymentMethods: asStringList(json['payment_methods']),
        categories:
            asList(json['categories'], MainSourceCategoryModel.fromJson),
      );

  static MainSourceModel? fromJsonOrNull(dynamic json) {
    final map = asMapOrNull(json);
    return map == null ? null : MainSourceModel.fromJson(map);
  }

  /// Used to cache the business config.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name_en': nameEn,
        'name_ar': nameAr,
        'name_ur': nameUr,
        'description_en': descriptionEn,
        'description_ar': descriptionAr,
        'icon': icon,
        'photo': photo,
        'phone': phone,
        'email': email,
        'delivery_fee': deliveryFee,
        'supports_delivery': supportsDelivery,
        'supports_pickup': supportsPickup,
        'payment_methods': paymentMethods,
        'categories': categories.map((e) => e.toJson()).toList(),
      };

  String get name => localized(nameEn, nameAr, nameUr);
  String get description => localized(descriptionEn, descriptionAr);
}

class MainSourceCategoryModel {
  final int? id;
  final int? mainSourceId;
  final String? nameEn;
  final String? nameAr;
  final String? nameUr;
  final String? image;
  final int productsCount;

  const MainSourceCategoryModel({
    this.id,
    this.mainSourceId,
    this.nameEn,
    this.nameAr,
    this.nameUr,
    this.image,
    this.productsCount = 0,
  });

  factory MainSourceCategoryModel.fromJson(Map<String, dynamic> json) =>
      MainSourceCategoryModel(
        id: parseInt(json['id']),
        mainSourceId: parseInt(json['main_source_id']),
        nameEn: parseString(json['name_en']),
        nameAr: parseString(json['name_ar']),
        nameUr: parseString(json['name_ur']),
        image: parseString(json['image']),
        productsCount: parseInt(json['products_count']) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'main_source_id': mainSourceId,
        'name_en': nameEn,
        'name_ar': nameAr,
        'name_ur': nameUr,
        'image': image,
        'products_count': productsCount,
      };

  String get name => localized(nameEn, nameAr, nameUr);
}
