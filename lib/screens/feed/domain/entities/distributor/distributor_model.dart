import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../presentation/distributor/utils/distributor_style.dart';
import 'checkout_options_model.dart';

class DistributorCity {
  int? id;
  String? nameEn;
  String? nameAr;

  DistributorCity.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    nameEn = parseString(json['name_en']);
    nameAr = parseString(json['name_ar']);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name_en': nameEn, 'name_ar': nameAr};

  String get name => localized(nameEn, nameAr);
}

class DistributorModel {
  int? id;
  String? nameEn;
  String? nameAr;
  String? nameUr;
  String? descriptionEn;
  String? descriptionAr;
  String? descriptionUr;
  String? logo;
  String? coverImage;
  double? latitude;
  double? longitude;
  String? address;
  String? tel;
  String? contactNumber;
  bool isOpen = true;
  bool isFeatured = false;
  double? ratings;
  int? ratingsCount;
  bool supportsDelivery = false;
  bool supportsPickup = false;
  double? deliveryFee;
  bool acceptsCash = false;
  bool acceptsBankTransfer = false;
  DistributorCity? city;
  double? distance;
  CheckoutOptionsModel? checkoutOptions;

  DistributorModel({this.id, this.nameEn, this.nameAr, this.logo});

  DistributorModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    nameEn = parseString(json['name_en']);
    nameAr = parseString(json['name_ar']);
    nameUr = parseString(json['name_ur']);
    descriptionEn = parseString(json['description_en']);
    descriptionAr = parseString(json['description_ar']);
    descriptionUr = parseString(json['description_ur']);
    logo = parseString(json['logo']);
    coverImage = parseString(json['cover_image']);
    latitude = parseDouble(json['latitude']);
    longitude = parseDouble(json['longitude']);
    address = parseString(json['address']);
    tel = parseString(json['tel']);
    contactNumber = parseString(json['contact_number']);
    isOpen = parseBool(json['is_open']) ?? true;
    isFeatured = parseBool(json['is_featured']) ?? false;
    ratings = parseDouble(json['ratings']);
    ratingsCount = parseInt(json['ratings_count']);
    supportsDelivery = parseBool(json['supports_delivery']) ?? false;
    supportsPickup = parseBool(json['supports_pickup']) ?? false;
    deliveryFee = parseDouble(json['delivery_fee']);
    acceptsCash = parseBool(json['accepts_cash']) ?? false;
    acceptsBankTransfer = parseBool(json['accepts_bank_transfer']) ?? false;
    city = json['city'] is Map<String, dynamic>
        ? DistributorCity.fromJson(json['city'])
        : null;
    distance = parseDouble(json['distance']);
    checkoutOptions = CheckoutOptionsModel.tryParse(json['checkout_options']);
  }

  /// Only the fields needed to restore the selected distributor locally.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name_en': nameEn,
        'name_ar': nameAr,
        'name_ur': nameUr,
        'logo': logo,
        'cover_image': coverImage,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'contact_number': contactNumber,
        'is_open': isOpen,
        'supports_delivery': supportsDelivery,
        'supports_pickup': supportsPickup,
        'city': city?.toJson(),
      };

  String get name => localized(nameEn, nameAr, nameUr);
  String get description =>
      localized(descriptionEn, descriptionAr, descriptionUr);
  String? get phone =>
      (contactNumber?.isNotEmpty ?? false) ? contactNumber : tel;
  bool get hasLocation => latitude != null && longitude != null;
}
