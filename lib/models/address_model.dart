import 'package:ufc_mobile/global/util/extension/string_extensions.dart';

class AddressModel {
  int? id;
  int? userId;
  double? latitude;
  double? longitude;
  bool? isDefault;
  String? address;
  String? city;
  String? label;
  String? landmark;
  String? firstName;
  String? lastName;
  String? countryCode;
  String? phoneNumber;
  String? alphaCode;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  AddressModel(
      {this.id,
      this.userId,
      this.latitude,
      this.longitude,
      this.isDefault,
      this.address,
      this.city,
      this.label,
      this.landmark,
      this.firstName,
      this.lastName,
      this.countryCode,
      this.phoneNumber,
      this.alphaCode,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString().toTryInt();
    userId = json['user_id']?.toString().toTryInt();
    latitude = json['latitude']?.toString().toTryDouble();
    longitude = json['longitude']?.toString().toTryDouble();
    isDefault = json['is_default'] == 1 || json['is_default'] == true;
    address = json['address'];
    city = json['city'];
    label = json['label'];
    landmark = json['landmark'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    alphaCode = json['alpha_code'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_default'] = isDefault;
    data['address'] = address;
    data['city'] = city;
    data['label'] = label;
    data['landmark'] = landmark;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['country_code'] = countryCode;
    data['phone_number'] = phoneNumber;
    data['alpha_code'] = alphaCode;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
