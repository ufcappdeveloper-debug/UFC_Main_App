import 'package:collection/collection.dart';

import 'order.dart';

class Data {
  int? id;
  int? orderId;
  int? issueId;
  String? details;
  dynamic image;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  Order? order;

  Data({
    this.id,
    this.orderId,
    this.issueId,
    this.details,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.order,
  });

  @override
  String toString() {
    return 'Data(id: $id, orderId: $orderId, issueId: $issueId, details: $details, image: $image, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, order: $order)';
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] as int?,
        orderId: json['order_id'] as int?,
        issueId: json['issue_id'] as int?,
        details: json['details'] as String?,
        image: json['image'] as dynamic,
        status: json['status'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        userId: json['user_id'] as int?,
        order: json['order'] == null
            ? null
            : Order.fromJson(json['order'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'issue_id': issueId,
        'details': details,
        'image': image,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'user_id': userId,
        'order': order?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Data) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      orderId.hashCode ^
      issueId.hashCode ^
      details.hashCode ^
      image.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      userId.hashCode ^
      order.hashCode;
}
