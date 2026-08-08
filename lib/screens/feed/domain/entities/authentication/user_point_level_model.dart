import 'package:ufc_mobile/global/util/extension/string_extensions.dart';

class UserPointLevelModel {
  int? id;
  String? nameAr;
  String? nameEn;
  String? descriptionAr;
  String? descriptionEn;
  double? minPoints;
  String? status;
  String? createdAt;
  String? updatedAt;
  double? maxPoint;

  UserPointLevelModel(
      {this.id,
      this.nameAr,
      this.nameEn,
      this.descriptionAr,
      this.descriptionEn,
      this.minPoints,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.maxPoint});

  UserPointLevelModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString().toTryInt();
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    descriptionAr = json['description_ar'];
    descriptionEn = json['description_en'];
    minPoints = json['min_points']?.toString().toTryDouble();
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    maxPoint = json['max_point']?.toString().toTryDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_ar'] = nameAr;
    data['name_en'] = nameEn;
    data['description_ar'] = descriptionAr;
    data['description_en'] = descriptionEn;
    data['min_points'] = minPoints;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['max_point'] = maxPoint;
    return data;
  }
}
