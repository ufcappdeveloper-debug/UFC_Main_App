import 'package:ufc_mobile/global/util/common/common_utils.dart';

class PhoneModel {
  int? id;
  int? userId;
  String? countryCode;
  String? phoneNumber;
  String? alphaCode;
  DateTime? verifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? externalRefId;

  PhoneModel({
    this.id,
    this.userId,
    this.countryCode,
    this.phoneNumber,
    this.alphaCode,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.externalRefId,
  });

  PhoneModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    userId = parseInt(json['user_id']);
    countryCode = parseString(json['country_code']);
    phoneNumber = parseString(json['phone_number']);
    alphaCode = parseString(json['alpha_code']);

    String verifiedat = parseString(json['verified_at']) ?? '';
    verifiedAt = verifiedat.isNotEmpty ? DateTime.parse(verifiedat) : null;

    String createdat = parseString(json['created_at']) ?? '';
    createdAt = createdat.isNotEmpty ? DateTime.parse(createdat) : null;

    String updatedat = parseString(json['updated_at']) ?? '';
    updatedAt = updatedat.isNotEmpty ? DateTime.parse(updatedat) : null;

    String deleteat = parseString(json['deleted_at']) ?? '';
    deletedAt = deleteat.isNotEmpty ? DateTime.parse(deleteat) : null;
    externalRefId = parseString(json['external_ref_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['country_code'] = countryCode;
    data['phone_number'] = phoneNumber;
    data['alpha_code'] = alphaCode;
    data['verified_at'] = verifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['external_ref_id'] = externalRefId;
    return data;
  }
}
