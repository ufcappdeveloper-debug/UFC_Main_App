import 'package:collection/collection.dart';

import 'order.dart';
import 'ticket_issue.dart';
import 'user.dart';

class TicketModel {
  int? id;
  int? orderId;
  int? issueId;
  String? details;
  String? image;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  TicketIssue? ticketIssue;
  User? user;
  Order? order;

  TicketModel({
    this.id,
    this.orderId,
    this.issueId,
    this.details,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.ticketIssue,
    this.user,
    this.order,
  });

  @override
  String toString() {
    return 'TicketModel(id: $id, orderId: $orderId, issueId: $issueId, details: $details, image: $image, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, ticketIssue: $ticketIssue, user: $user, order: $order)';
  }

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        id: json['id'] as int?,
        orderId: json['order_id'] as int?,
        issueId: json['issue_id'] as int?,
        details: json['details'] as String?,
        image: json['image'] as String?,
        status: json['status'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        userId: json['user_id'] as int?,
        ticketIssue: json['ticket_issue'] == null
            ? null
            : TicketIssue.fromJson(
                json['ticket_issue'] as Map<String, dynamic>),
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
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
        'ticket_issue': ticketIssue?.toJson(),
        'user': user?.toJson(),
        'order': order?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! TicketModel) return false;
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
      ticketIssue.hashCode ^
      user.hashCode ^
      order.hashCode;
}
