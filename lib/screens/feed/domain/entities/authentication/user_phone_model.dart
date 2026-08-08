class UserPhoneModel {
  String? countryCode;
  String? phoneNumber;
  String? alphaCode;
  String? verifiedAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  UserPhoneModel(
      {this.countryCode,
      this.phoneNumber,
      this.alphaCode,
      this.verifiedAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  UserPhoneModel.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    alphaCode = json['alpha_code'];
    verifiedAt = json['verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = countryCode;
    data['phone_number'] = phoneNumber;
    data['alpha_code'] = alphaCode;
    data['verified_at'] = verifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
