import 'package:collection/collection.dart';

class Group {
  int? id;
  String? nameEn;
  String? nameAr;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  Group({
    this.id,
    this.nameEn,
    this.nameAr,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Group(id: $id, nameEn: $nameEn, nameAr: $nameAr, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json['id'] as int?,
        nameEn: json['name_en'] as String?,
        nameAr: json['name_ar'] as String?,
        deletedAt: json['deleted_at'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_en': nameEn,
        'name_ar': nameAr,
        'deleted_at': deletedAt,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Group) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      nameEn.hashCode ^
      nameAr.hashCode ^
      deletedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
