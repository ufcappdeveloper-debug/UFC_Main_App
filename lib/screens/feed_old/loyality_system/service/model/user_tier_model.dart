import 'package:collection/collection.dart';

class UserTierModel {
  String? status;
  UserData? data;

  UserTierModel({this.status, this.data});

  factory UserTierModel.fromJson(Map<String, dynamic> json) {
    return UserTierModel(
      status: json['status'] as String?,
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserTierModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode;
}

class UserData {
  int? userPoints;
  int? currentTierIndex;
  List<Tier>? tiers;

  UserData({this.userPoints, this.currentTierIndex, this.tiers});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userPoints: json['user_points'] as int?,
      currentTierIndex: json['current_tier_index'] as int?,
      tiers: (json['tiers'] as List<dynamic>?)
          ?.map((e) => Tier.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_points': userPoints,
        'current_tier_index': currentTierIndex,
        'tiers': tiers?.map((e) => e.toJson()).toList(),
      };
}

class Tier {
  int? id;
  String? name;
  String? description;
  int? minPoints;
  int? maxPoints;
  int? pointsPerUnitSpent;

  Tier(
      {this.id,
      this.name,
      this.description,
      this.minPoints,
      this.maxPoints,
      this.pointsPerUnitSpent});

  factory Tier.fromJson(Map<String, dynamic> json) {
    return Tier(
        id: json['id'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        minPoints: json['min_points'] as int?,
        maxPoints: json['max_points'] as int?,
        pointsPerUnitSpent: json['points_per_unit_spent'] as int?);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'min_points': minPoints,
        'max_points': maxPoints,
      };
}
