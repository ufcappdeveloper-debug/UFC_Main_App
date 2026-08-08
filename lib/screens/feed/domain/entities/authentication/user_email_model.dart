import 'package:ufc_mobile/global/util/extension/string_extensions.dart';

class UserEmailModel {
  int? id;
  int? userId;
  String? email;
  String? verifiedAt;
  String? createdAt;
  String? updatedAt;

  UserEmailModel(
      {this.id,
      this.userId,
      this.email,
      this.verifiedAt,
      this.createdAt,
      this.updatedAt});

  UserEmailModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString().toTryInt();
    userId = json['user_id']?.toString().toTryInt();
    email = json['email'];
    verifiedAt = json['verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['email'] = email;
    data['verified_at'] = verifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
