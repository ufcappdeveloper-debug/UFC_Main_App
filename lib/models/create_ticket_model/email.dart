import 'package:collection/collection.dart';

class Email {
  int? id;
  int? userId;
  String? email;
  String? verifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Email({
    this.id,
    this.userId,
    this.email,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @override
  String toString() {
    return 'Email(id: $id, userId: $userId, email: $email, verifiedAt: $verifiedAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  factory Email.fromJson(Map<String, dynamic> json) => Email(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        email: json['email'] as String?,
        verifiedAt: json['verified_at'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        deletedAt: json['deleted_at'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'email': email,
        'verified_at': verifiedAt,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Email) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      email.hashCode ^
      verifiedAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
}
