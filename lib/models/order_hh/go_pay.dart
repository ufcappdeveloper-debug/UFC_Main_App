import 'package:collection/collection.dart';

class GoPay {
  int? id;
  int? orderId;
  String? billNumber;
  String? entityActivityId;
  String? customerFullName;
  String? customerMobileNumber;
  String? issueDate;
  String? expireDate;
  String? amount;
  String? sadadNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  GoPay({
    this.id,
    this.orderId,
    this.billNumber,
    this.entityActivityId,
    this.customerFullName,
    this.customerMobileNumber,
    this.issueDate,
    this.expireDate,
    this.amount,
    this.sadadNumber,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'GoPay(id: $id, orderId: $orderId, billNumber: $billNumber, entityActivityId: $entityActivityId, customerFullName: $customerFullName, customerMobileNumber: $customerMobileNumber, issueDate: $issueDate, expireDate: $expireDate, amount: $amount, sadadNumber: $sadadNumber, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory GoPay.fromJson(Map<String, dynamic> json) => GoPay(
        id: json['id'] as int?,
        orderId: json['order_id'] as int?,
        billNumber: json['bill_number'] as String?,
        entityActivityId: json['entity_activity_id'] as String?,
        customerFullName: json['customer_full_name'] as String?,
        customerMobileNumber: json['customer_mobile_number'] as String?,
        issueDate: json['issue_date'] as String?,
        expireDate: json['expire_date'] as String?,
        amount: json['amount'] as String?,
        sadadNumber: json['sadad_number'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'bill_number': billNumber,
        'entity_activity_id': entityActivityId,
        'customer_full_name': customerFullName,
        'customer_mobile_number': customerMobileNumber,
        'issue_date': issueDate,
        'expire_date': expireDate,
        'amount': amount,
        'sadad_number': sadadNumber,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! GoPay) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      orderId.hashCode ^
      billNumber.hashCode ^
      entityActivityId.hashCode ^
      customerFullName.hashCode ^
      customerMobileNumber.hashCode ^
      issueDate.hashCode ^
      expireDate.hashCode ^
      amount.hashCode ^
      sadadNumber.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
