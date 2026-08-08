import 'package:collection/collection.dart';
import 'package:ufc_mobile/models/common/phone_models.dart';

import 'email.dart';

class User {
  int? id;
  String? name;
  String? lastName;
  String? city;
  String? dob;
  String? gender;
  String? occupation;
  String? profilePicture;
  dynamic invitedBy;
  String? inviteCode;
  bool? newsletter;
  int? walletAmount;
  int? totalPoints;
  int? usedPoints;
  int? remainingPoints;
  int? numberOfOrders;
  int? totalOrderAmount;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? preferredShop;
  dynamic deletedAt;
  PhoneModel? phone;
  Email? email;

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
  });

  @override
  String toString() {
    return 'User(id: $id, name: $name, lastName: $lastName, city: $city, dob: $dob, gender: $gender, occupation: $occupation, profilePicture: $profilePicture, invitedBy: $invitedBy, inviteCode: $inviteCode, newsletter: $newsletter, walletAmount: $walletAmount, totalPoints: $totalPoints, usedPoints: $usedPoints, remainingPoints: $remainingPoints, numberOfOrders: $numberOfOrders, totalOrderAmount: $totalOrderAmount, createdAt: $createdAt, updatedAt: $updatedAt, preferredShop: $preferredShop, deletedAt: $deletedAt, phone: $phone, email: $email)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String?,
        lastName: json['last_name'] as String?,
        city: json['city'] as String?,
        dob: json['dob'] as String?,
        gender: json['gender'] as String?,
        occupation: json['occupation'] as String?,
        profilePicture: json['profile_picture'] as String?,
        invitedBy: json['invited_by'] as dynamic,
        inviteCode: json['invite_code'] as String?,
        newsletter: json['newsletter'] as bool?,
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
        preferredShop: json['preferred_shop'] as int?,
        deletedAt: json['deleted_at'] as dynamic,
        phone: json['phone'] == null
            ? null
            : PhoneModel.fromJson(json['phone'] as Map<String, dynamic>),
        email: json['email'] == null
            ? null
            : Email.fromJson(json['email'] as Map<String, dynamic>),
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
        'phone': phone?.toJson(),
        'email': email?.toJson(),
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
      email.hashCode;
}
