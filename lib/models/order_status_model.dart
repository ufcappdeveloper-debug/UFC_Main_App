import 'package:collection/collection.dart';

class OrderStatusModel {
  int? id;
  int? orderId;
  int? userId;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrderStatusModel({
    this.id,
    this.orderId,
    this.userId,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'OrderStatusModel(id: $id, orderId: $orderId, userId: $userId, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      id: json['id'] as int?,
      orderId: json['order_id'] as int?,
      userId: json['user_id'] as int?,
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'user_id': userId,
        'description': description,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderStatusModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      orderId.hashCode ^
      userId.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
