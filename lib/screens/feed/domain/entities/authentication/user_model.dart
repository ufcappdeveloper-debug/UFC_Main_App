import 'package:ufc_mobile/models/address_model.dart';

import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_email_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_phone_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_point_level_model.dart';
import 'package:ufc_mobile/global/util/extension/string_extensions.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/station/station_model.dart';

class UserModel {
  int? id;
  String? name;
  String? middleName;
  String? lastName;
  String? city;
  String? dob;
  String? gender;
  String? occupation;
  String? profilePicture;
  String? invitedBy;
  String? inviteCode;
  bool? newsletter;
  bool? pushNotifAll;
  bool? pushNotifAccountOrders;
  bool? pushNotifOffersPromotion;
  bool? emailNotifAll;
  bool? emailNotifOfferProducts;
  bool? smsNotifAccountOrders;
  double? totalPoints;
  double? usedPoints;
  double? remainingPoints;
  int? numberOfOrders;
  double? totalOrderAmount;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? preferredShop;
  String? externalRef;
  List<int>? favoriteShops;
  List<int>? favoriteProducts;
  UserPointLevelModel? pointLevel;
  int? vatPercentage;
  UserPhoneModel? phone;
  UserEmailModel? email;
  double? walletAmount;
  StationModel? preferredShopDetails;
  List<AddressModel>? addresses;

  UserModel({
    this.id,
    this.name,
    this.middleName,
    this.lastName,
    this.city,
    this.dob,
    this.gender,
    this.occupation,
    this.profilePicture,
    this.invitedBy,
    this.inviteCode,
    this.newsletter,
    this.pushNotifAll,
    this.pushNotifAccountOrders,
    this.pushNotifOffersPromotion,
    this.emailNotifAll,
    this.emailNotifOfferProducts,
    this.smsNotifAccountOrders,
    this.totalPoints,
    this.usedPoints,
    this.remainingPoints,
    this.numberOfOrders,
    this.totalOrderAmount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.preferredShop,
    this.externalRef,
    this.favoriteShops,
    this.favoriteProducts,
    this.pointLevel,
    this.vatPercentage,
    this.phone,
    this.email,
    this.walletAmount,
    this.preferredShopDetails,
    this.addresses,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString().toTryInt();
    name = json['name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    city = json['city'];
    dob = json['dob'];
    gender = json['gender'];
    occupation = json['occupation'];
    profilePicture = json['profile_picture'];
    invitedBy = json['invited_by'];
    inviteCode = json['invite_code'];
    newsletter =
        json['newsletter'] == null || json['newsletter'] == 0 ? false : true;
    pushNotifAll = json['push_notif_all'];
    pushNotifAccountOrders = json['push_notif_account_orders'];
    pushNotifOffersPromotion = json['push_notif_offers_promotion'];
    emailNotifAll = json['email_notif_all'];
    emailNotifOfferProducts = json['email_notif_offer_products'];
    smsNotifAccountOrders = json['sms_notif_account_orders'];
    totalPoints = json['total_points']?.toString().toTryDouble();
    usedPoints = json['used_points']?.toString().toTryDouble();
    remainingPoints = json['remaining_points']?.toString().toTryDouble();
    numberOfOrders = json['number_of_orders']?.toString().toTryInt();
    totalOrderAmount =
        json['total_order_amount']?.toString().toTryDouble() ?? 0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    preferredShop = json['preferred_shop']?.toString().toTryInt();
    externalRef = json['external_ref'];
    walletAmount = json['wallet_amount']?.toString().toTryDouble() ?? 0;
    favoriteShops =
        json['favoriteShops'] == null ? [] : json['favoriteShops'].cast<int>();
    favoriteProducts = json['faveratedProducts'] == null
        ? []
        : json['faveratedProducts'].cast<int>();
    pointLevel = json['point_level'] != null
        ? UserPointLevelModel.fromJson(json['point_level'])
        : null;
    vatPercentage = json['vat_percentage']?.toString().toTryInt() ?? 0;
    phone =
        json['phone'] != null ? UserPhoneModel.fromJson(json['phone']) : null;
    email =
        json['email'] != null ? UserEmailModel.fromJson(json['email']) : null;
    preferredShopDetails = json['prefered_shop_details'] != null
        ? StationModel.fromJson(json['prefered_shop_details'])
        : null;
    if (json['addresses'] != null) {
      addresses = <AddressModel>[];
      json['addresses'].forEach((v) {
        addresses!.add(AddressModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['city'] = city;
    data['dob'] = dob;
    data['gender'] = gender;
    data['occupation'] = occupation;
    data['profile_picture'] = profilePicture;
    data['invited_by'] = invitedBy;
    data['invite_code'] = inviteCode;
    data['newsletter'] = newsletter == false ? 0 : 1;
    data['push_notif_all'] = pushNotifAll;
    data['push_notif_account_orders'] = pushNotifAccountOrders;
    data['push_notif_offers_promotion'] = pushNotifOffersPromotion;
    data['email_notif_all'] = emailNotifAll;
    data['email_notif_offer_products'] = emailNotifOfferProducts;
    data['sms_notif_account_orders'] = smsNotifAccountOrders;
    data['total_points'] = totalPoints;
    data['used_points'] = usedPoints;
    data['remaining_points'] = remainingPoints;
    data['number_of_orders'] = numberOfOrders;
    data['total_order_amount'] = totalOrderAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['preferred_shop'] = preferredShop;
    data['external_ref'] = externalRef;
    data['wallet_amount'] = walletAmount;
    data['favoriteShops'] = favoriteShops;
    data['faveratedProducts'] = favoriteProducts;
    if (pointLevel != null) {
      data['point_level'] = pointLevel!.toJson();
    }
    data['vat_percentage'] = vatPercentage;
    if (phone != null) {
      data['phone'] = phone!.toJson();
    }
    if (email != null) {
      data['email'] = email!.toJson();
    }
    if (preferredShopDetails != null) {
      data['prefered_shop_details'] = preferredShopDetails!.toJson();
    }
    return data;
  }
}
extension UserModelCopy on UserModel {
  UserModel copyWith({
    int? id,
    String? name,
    String? middleName,
    String? lastName,
    String? city,
    String? dob,
    String? gender,
    String? occupation,
    String? profilePicture,
    String? invitedBy,
    String? inviteCode,
    bool? newsletter,
    bool? pushNotifAll,
    bool? pushNotifAccountOrders,
    bool? pushNotifOffersPromotion,
    bool? emailNotifAll,
    bool? emailNotifOfferProducts,
    bool? smsNotifAccountOrders,
    double? totalPoints,
    double? usedPoints,
    double? remainingPoints,
    int? numberOfOrders,
    double? totalOrderAmount,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    int? preferredShop,
    String? externalRef,
    List<int>? favoriteShops,
    List<int>? favoriteProducts,
    UserPointLevelModel? pointLevel,
    int? vatPercentage,
    UserPhoneModel? phone,
    UserEmailModel? email,
    double? walletAmount,
    StationModel? preferredShopDetails,
    List<AddressModel>? addresses,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      profilePicture: profilePicture ?? this.profilePicture,
      invitedBy: invitedBy ?? this.invitedBy,
      inviteCode: inviteCode ?? this.inviteCode,
      newsletter: newsletter ?? this.newsletter,
      pushNotifAll: pushNotifAll ?? this.pushNotifAll,
      pushNotifAccountOrders:
      pushNotifAccountOrders ?? this.pushNotifAccountOrders,
      pushNotifOffersPromotion:
      pushNotifOffersPromotion ?? this.pushNotifOffersPromotion,
      emailNotifAll: emailNotifAll ?? this.emailNotifAll,
      emailNotifOfferProducts:
      emailNotifOfferProducts ?? this.emailNotifOfferProducts,
      smsNotifAccountOrders:
      smsNotifAccountOrders ?? this.smsNotifAccountOrders,
      totalPoints: totalPoints ?? this.totalPoints,
      usedPoints: usedPoints ?? this.usedPoints,
      remainingPoints: remainingPoints ?? this.remainingPoints,
      numberOfOrders: numberOfOrders ?? this.numberOfOrders,
      totalOrderAmount: totalOrderAmount ?? this.totalOrderAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      preferredShop: preferredShop ?? this.preferredShop,
      externalRef: externalRef ?? this.externalRef,
      favoriteShops: favoriteShops ?? this.favoriteShops,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      pointLevel: pointLevel ?? this.pointLevel,
      vatPercentage: vatPercentage ?? this.vatPercentage,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      walletAmount: walletAmount ?? this.walletAmount,
      preferredShopDetails: preferredShopDetails ?? this.preferredShopDetails,
      addresses: addresses ?? this.addresses,
    );
  }
}
class EditUserResponse {
  final UserModel user;
  final String message;

  EditUserResponse({required this.user, required this.message});
}
