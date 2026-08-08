import 'package:ufc_mobile/global/util/common/common_utils.dart';

import '../../../../../global/shared/constants/constants.dart';

class VaccineType {
  int? id;
  String? vaccineEn;
  String? vaccineAr;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  VaccineType({
    this.id,
    this.vaccineEn,
    this.vaccineAr,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  VaccineType.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    vaccineEn = parseString(json['vaccine_en']);
    vaccineAr = parseString(json['vaccine_ar']);
    deletedAt = parseString(json['deleted_at']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vaccine_en'] = vaccineEn;
    data['vaccine_ar'] = vaccineAr;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  String get vaccineName =>
      isArabic ? vaccineAr ?? vaccineEn ?? '' : vaccineEn ?? '';
}
