import 'package:ufc_mobile/global/util/common/common_utils.dart';

class MemberRole {
  final int? id;
  final String? slug;
  final String? name;

  const MemberRole({this.id, this.slug, this.name});

  factory MemberRole.fromJson(Map<String, dynamic> json) => MemberRole(
        id: parseInt(json['id']),
        slug: parseString(json['slug']),
        name: parseString(json['name']),
      );

  Map<String, dynamic> toJson() => {'id': id, 'slug': slug, 'name': name};
}

/// A member of the logged-in owner's farm.
class FarmMemberModel {
  final int? id;
  final int? memberUserId;
  final String? name;
  final String? email;
  final String? countryCode;
  final String? phoneNumber;
  final MemberRole? role;
  final List<String> permissions;
  final bool canViewFinance;
  final String? status;

  const FarmMemberModel({
    this.id,
    this.memberUserId,
    this.name,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.role,
    this.permissions = const [],
    this.canViewFinance = false,
    this.status,
  });

  factory FarmMemberModel.fromJson(Map<String, dynamic> json) =>
      FarmMemberModel(
        id: parseInt(json['id']),
        memberUserId: parseInt(json['member_user_id']),
        name: parseString(json['name']),
        email: parseString(json['email']),
        countryCode: parseString(json['country_code']),
        phoneNumber: parseString(json['phone_number']),
        role: json['role'] is Map<String, dynamic>
            ? MemberRole.fromJson(json['role'])
            : null,
        permissions: json['permissions'] is List
            ? (json['permissions'] as List).map((e) => e.toString()).toList()
            : const [],
        canViewFinance: parseBool(json['can_view_finance']) ?? false,
        status: parseString(json['status']),
      );

  String get displayPhone =>
      [countryCode ?? '+966', phoneNumber ?? ''].join(' ').trim();
}

/// A farm the logged-in user is a member of (`/members/accounts`).
class MemberAccountModel {
  final int? membershipId;
  final int? ownerUserId;
  final String? ownerName;
  final String? ownerCountryCode;
  final String? ownerPhoneNumber;
  final MemberRole? role;
  final List<String> permissions;
  final bool canViewFinance;

  const MemberAccountModel({
    this.membershipId,
    this.ownerUserId,
    this.ownerName,
    this.ownerCountryCode,
    this.ownerPhoneNumber,
    this.role,
    this.permissions = const [],
    this.canViewFinance = false,
  });

  factory MemberAccountModel.fromJson(Map<String, dynamic> json) =>
      MemberAccountModel(
        membershipId: parseInt(json['membership_id']),
        ownerUserId: parseInt(json['owner_user_id']),
        ownerName: parseString(json['owner_name']),
        ownerCountryCode: parseString(json['owner_country_code']),
        ownerPhoneNumber: parseString(json['owner_phone_number']),
        role: json['role'] is Map<String, dynamic>
            ? MemberRole.fromJson(json['role'])
            : null,
        permissions: json['permissions'] is List
            ? (json['permissions'] as List).map((e) => e.toString()).toList()
            : const [],
        canViewFinance: parseBool(json['can_view_finance']) ?? false,
      );

  Map<String, dynamic> toJson() => {
        'membership_id': membershipId,
        'owner_user_id': ownerUserId,
        'owner_name': ownerName,
        'owner_country_code': ownerCountryCode,
        'owner_phone_number': ownerPhoneNumber,
        'role': role?.toJson(),
        'permissions': permissions,
        'can_view_finance': canViewFinance,
      };

  /// Owner name, else the owner's phone.
  String get label => (ownerName?.trim().isNotEmpty ?? false)
      ? ownerName!
      : '${ownerCountryCode ?? ''} ${ownerPhoneNumber ?? ''}'.trim();
}
