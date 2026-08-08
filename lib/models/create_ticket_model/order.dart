import 'package:collection/collection.dart';

class Order {
  int? id;
  dynamic shopId;
  int? userId;
  dynamic addressId;
  double? amount;
  int? womEarning;
  int? shopEarning;
  int? couponAmount;
  int? payableAmount;
  int? pointsAmount;
  int? pointsEarned;
  int? pointsUsed;
  int? vatAmount;
  String? orderStatus;
  String? orderType;
  String? paymentStatus;
  dynamic couponCode;
  dynamic remarks;
  dynamic carId;
  dynamic lastUpdatedBy;
  dynamic paymentReference;
  dynamic estimatedTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  Order({
    this.id,
    this.shopId,
    this.userId,
    this.addressId,
    this.amount,
    this.womEarning,
    this.shopEarning,
    this.couponAmount,
    this.payableAmount,
    this.pointsAmount,
    this.pointsEarned,
    this.pointsUsed,
    this.vatAmount,
    this.orderStatus,
    this.orderType,
    this.paymentStatus,
    this.couponCode,
    this.remarks,
    this.carId,
    this.lastUpdatedBy,
    this.paymentReference,
    this.estimatedTime,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Order(id: $id, shopId: $shopId, userId: $userId, addressId: $addressId, amount: $amount, womEarning: $womEarning, shopEarning: $shopEarning, couponAmount: $couponAmount, payableAmount: $payableAmount, pointsAmount: $pointsAmount, pointsEarned: $pointsEarned, pointsUsed: $pointsUsed, vatAmount: $vatAmount, orderStatus: $orderStatus, orderType: $orderType, paymentStatus: $paymentStatus, couponCode: $couponCode, remarks: $remarks, carId: $carId, lastUpdatedBy: $lastUpdatedBy, paymentReference: $paymentReference, estimatedTime: $estimatedTime, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as int?,
        shopId: json['shop_id'] as dynamic,
        userId: json['user_id'] as int?,
        addressId: json['address_id'] as dynamic,
        amount: json['amount'] != null
            ? double.parse(json['amount'].toString())
            : null,
        womEarning: json['wom_earning'] as int?,
        shopEarning: json['shop_earning'] as int?,
        couponAmount: json['coupon_amount'] as int?,
        payableAmount: json['payable_amount'] as int?,
        pointsAmount: json['points_amount'] as int?,
        pointsEarned: json['points_earned'] as int?,
        pointsUsed: json['points_used'] as int?,
        vatAmount: json['vat_amount'] as int?,
        orderStatus: json['order_status'] as String?,
        orderType: json['order_type'] as String?,
        paymentStatus: json['payment_status'] as String?,
        couponCode: json['coupon_code'] as dynamic,
        remarks: json['remarks'] as dynamic,
        carId: json['car_id'] as dynamic,
        lastUpdatedBy: json['last_updated_by'] as dynamic,
        paymentReference: json['payment_reference'] as dynamic,
        estimatedTime: json['estimated_time'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'shop_id': shopId,
        'user_id': userId,
        'address_id': addressId,
        'amount': amount,
        'wom_earning': womEarning,
        'shop_earning': shopEarning,
        'coupon_amount': couponAmount,
        'payable_amount': payableAmount,
        'points_amount': pointsAmount,
        'points_earned': pointsEarned,
        'points_used': pointsUsed,
        'vat_amount': vatAmount,
        'order_status': orderStatus,
        'order_type': orderType,
        'payment_status': paymentStatus,
        'coupon_code': couponCode,
        'remarks': remarks,
        'car_id': carId,
        'last_updated_by': lastUpdatedBy,
        'payment_reference': paymentReference,
        'estimated_time': estimatedTime,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Order) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      shopId.hashCode ^
      userId.hashCode ^
      addressId.hashCode ^
      amount.hashCode ^
      womEarning.hashCode ^
      shopEarning.hashCode ^
      couponAmount.hashCode ^
      payableAmount.hashCode ^
      pointsAmount.hashCode ^
      pointsEarned.hashCode ^
      pointsUsed.hashCode ^
      vatAmount.hashCode ^
      orderStatus.hashCode ^
      orderType.hashCode ^
      paymentStatus.hashCode ^
      couponCode.hashCode ^
      remarks.hashCode ^
      carId.hashCode ^
      lastUpdatedBy.hashCode ^
      paymentReference.hashCode ^
      estimatedTime.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
