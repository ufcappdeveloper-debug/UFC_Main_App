import 'package:ufc_mobile/global/util/common/common_utils.dart';

class EmailModel {
  int? id;
  int? userId;
  String? email;
  String? verifiedAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? externalRefId;

  EmailModel({
    this.id,
    this.userId,
    this.email,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.externalRefId,
  });

  EmailModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    userId = parseInt(json['user_id']);
    email = parseString(json['email']);
    verifiedAt = parseString(json['verified_at']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    deletedAt = parseString(json['deleted_at']);
    externalRefId = parseInt(json['external_ref_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['email'] = email;
    data['verified_at'] = verifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['external_ref_id'] = externalRefId;
    return data;
  }
}
