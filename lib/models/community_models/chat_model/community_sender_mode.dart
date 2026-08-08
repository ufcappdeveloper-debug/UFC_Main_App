import 'package:ufc_mobile/models/common/emial_model.dart';
import 'package:ufc_mobile/models/common/phone_models.dart';

class CommunitySenderModel {
  int? id;
  String? name;
  String? middleName;
  String? lastName;
  String? profilePic;
  int? vatPercentage;
  PhoneModel? phone;
  EmailModel? email;
  CommunitySenderModel({
    this.id,
    this.name,
    this.middleName,
    this.lastName,
    this.profilePic,
    this.vatPercentage,
    this.phone,
    this.email,
  });

  CommunitySenderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    profilePic = json['profile_picture'];
    vatPercentage = json['vat_percentage'];
    phone = json['phone'] != null ? PhoneModel.fromJson(json['phone']) : null;
    email = json['email'] != null ? EmailModel.fromJson(json['email']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['profile_picture'] = profilePic;
    data['vat_percentage'] = vatPercentage;
    if (phone != null) {
      data['phone'] = phone?.toJson();
    }
    if (email != null) {
      data['email'] = email?.toJson();
    }

    return data;
  }
}
