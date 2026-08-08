import 'package:collection/collection.dart';

import 'address.dart';
import 'email.dart';

class User {
  int? id;
  String? name;
  dynamic lastName;
  dynamic city;
  dynamic dob;
  dynamic gender;
  dynamic occupation;
  String? profilePicture;
  dynamic invitedBy;
  dynamic inviteCode;
  bool? newsletter;
  bool? pushNotifAll;
  bool? pushNotifAccountOrders;
  bool? pushNotifOffersPromotion;
  bool? emailNotifAll;
  bool? emailNotifOfferProducts;
  bool? smsNotifAccountOrders;
  int? walletAmount;
  int? totalPoints;
  int? usedPoints;
  int? remainingPoints;
  int? numberOfOrders;
  int? totalOrderAmount;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic preferredShop;
  dynamic deletedAt;
  dynamic phone;
  Email? email;
  List<Address>? addresses;

  User({
    this.id,
    this.name,
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
    this.walletAmount,
    this.totalPoints,
    this.usedPoints,
    this.remainingPoints,
    this.numberOfOrders,
    this.totalOrderAmount,
    this.createdAt,
    this.updatedAt,
    this.preferredShop,
    this.deletedAt,
    this.phone,
    this.email,
    this.addresses,
  });

  @override
  String toString() {
    return 'User(id: $id, name: $name, lastName: $lastName, city: $city, dob: $dob, gender: $gender, occupation: $occupation, profilePicture: $profilePicture, invitedBy: $invitedBy, inviteCode: $inviteCode, newsletter: $newsletter, pushNotifAll: $pushNotifAll, pushNotifAccountOrders: $pushNotifAccountOrders, pushNotifOffersPromotion: $pushNotifOffersPromotion, emailNotifAll: $emailNotifAll, emailNotifOfferProducts: $emailNotifOfferProducts, smsNotifAccountOrders: $smsNotifAccountOrders, walletAmount: $walletAmount, totalPoints: $totalPoints, usedPoints: $usedPoints, remainingPoints: $remainingPoints, numberOfOrders: $numberOfOrders, totalOrderAmount: $totalOrderAmount, createdAt: $createdAt, updatedAt: $updatedAt, preferredShop: $preferredShop, deletedAt: $deletedAt, phone: $phone, email: $email, addresses: $addresses)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String?,
        lastName: json['last_name'] as dynamic,
        city: json['city'] as dynamic,
        dob: json['dob'] as dynamic,
        gender: json['gender'] as dynamic,
        occupation: json['occupation'] as dynamic,
        profilePicture: json['profile_picture'] as String?,
        invitedBy: json['invited_by'] as dynamic,
        inviteCode: json['invite_code'] as dynamic,
        newsletter: json['newsletter'] as bool?,
        pushNotifAll: json['push_notif_all'] as bool?,
        pushNotifAccountOrders: json['push_notif_account_orders'] as bool?,
        pushNotifOffersPromotion: json['push_notif_offers_promotion'] as bool?,
        emailNotifAll: json['email_notif_all'] as bool?,
        emailNotifOfferProducts: json['email_notif_offer_products'] as bool?,
        smsNotifAccountOrders: json['sms_notif_account_orders'] as bool?,
        walletAmount: json['wallet_amount'] as int?,
        totalPoints: json['total_points'] as int?,
        usedPoints: json['used_points'] as int?,
        remainingPoints: json['remaining_points'] as int?,
        numberOfOrders: json['number_of_orders'] as int?,
        totalOrderAmount: json['total_order_amount'] as int?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        preferredShop: json['preferred_shop'] as dynamic,
        deletedAt: json['deleted_at'] as dynamic,
        phone: json['phone'] as dynamic,
        email: json['email'] == null
            ? null
            : Email.fromJson(json['email'] as Map<String, dynamic>),
        addresses: (json['addresses'] as List<dynamic>?)
            ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'last_name': lastName,
        'city': city,
        'dob': dob,
        'gender': gender,
        'occupation': occupation,
        'profile_picture': profilePicture,
        'invited_by': invitedBy,
        'invite_code': inviteCode,
        'newsletter': newsletter,
        'push_notif_all': pushNotifAll,
        'push_notif_account_orders': pushNotifAccountOrders,
        'push_notif_offers_promotion': pushNotifOffersPromotion,
        'email_notif_all': emailNotifAll,
        'email_notif_offer_products': emailNotifOfferProducts,
        'sms_notif_account_orders': smsNotifAccountOrders,
        'wallet_amount': walletAmount,
        'total_points': totalPoints,
        'used_points': usedPoints,
        'remaining_points': remainingPoints,
        'number_of_orders': numberOfOrders,
        'total_order_amount': totalOrderAmount,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'preferred_shop': preferredShop,
        'deleted_at': deletedAt,
        'phone': phone,
        'email': email?.toJson(),
        'addresses': addresses?.map((e) => e.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! User) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      lastName.hashCode ^
      city.hashCode ^
      dob.hashCode ^
      gender.hashCode ^
      occupation.hashCode ^
      profilePicture.hashCode ^
      invitedBy.hashCode ^
      inviteCode.hashCode ^
      newsletter.hashCode ^
      pushNotifAll.hashCode ^
      pushNotifAccountOrders.hashCode ^
      pushNotifOffersPromotion.hashCode ^
      emailNotifAll.hashCode ^
      emailNotifOfferProducts.hashCode ^
      smsNotifAccountOrders.hashCode ^
      walletAmount.hashCode ^
      totalPoints.hashCode ^
      usedPoints.hashCode ^
      remainingPoints.hashCode ^
      numberOfOrders.hashCode ^
      totalOrderAmount.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      preferredShop.hashCode ^
      deletedAt.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      addresses.hashCode;
}
