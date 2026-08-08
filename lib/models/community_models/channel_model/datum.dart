import 'package:collection/collection.dart';

import 'group.dart';

class ChannelModel {
  int? id;
  String? nameEn;
  String? nameAr;
  dynamic icon;
  String? descriptionEn;
  dynamic descriptionAr;
  String? status;
  int? groupId;
  bool? allowUsersToSend;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  Group? group;

  ChannelModel({
    this.id,
    this.nameEn,
    this.nameAr,
    this.icon,
    this.descriptionEn,
    this.descriptionAr,
    this.status,
    this.groupId,
    this.allowUsersToSend,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.group,
  });

  @override
  String toString() {
    return 'ChannelModel(id: $id, nameEn: $nameEn, nameAr: $nameAr, icon: $icon, descriptionEn: $descriptionEn, descriptionAr: $descriptionAr, status: $status, groupId: $groupId, allowUsersToSend: $allowUsersToSend, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, group: $group)';
  }

  factory ChannelModel.fromJson(Map<String, dynamic> json) => ChannelModel(
        id: json['id'] as int?,
        nameEn: json['name_en'] as String?,
        nameAr: json['name_ar'] as String?,
        icon: json['icon'] as dynamic,
        descriptionEn: json['description_en'] as String?,
        descriptionAr: json['description_ar'] as dynamic,
        status: json['status'] as String?,
        groupId: json['group_id'] as int?,
        allowUsersToSend: json['allow_users_to_send'] as bool?,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        group: json['group'] == null
            ? null
            : Group.fromJson(json['group'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_en': nameEn,
        'name_ar': nameAr,
        'icon': icon,
        'description_en': descriptionEn,
        'description_ar': descriptionAr,
        'status': status,
        'group_id': groupId,
        'allow_users_to_send': allowUsersToSend,
        'deleted_at': deletedAt,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'group': group?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! ChannelModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      nameEn.hashCode ^
      nameAr.hashCode ^
      icon.hashCode ^
      descriptionEn.hashCode ^
      descriptionAr.hashCode ^
      status.hashCode ^
      groupId.hashCode ^
      allowUsersToSend.hashCode ^
      deletedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      group.hashCode;
}
