import 'package:collection/collection.dart';

import 'order_item.dart';

class OrderH {
  int? id;
  dynamic shopId;
  int? userId;
  String? amount;
  String? womEarning;
  String? shopEarning;
  String? couponAmount;
  String? payableAmount;
  String? pointsAmount;
  String? pointsEarned;
  String? pointsUsed;
  String? vatAmount;
  String? orderStatus;
  String? orderType;
  String? paymentStatus;
  dynamic paymentMethod;
  dynamic couponCode;
  dynamic remarks;
  dynamic carId;
  dynamic lastUpdatedBy;
  dynamic paymentReference;
  dynamic estimatedTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic shop;
  dynamic car;
  List<OrderItem>? orderItems;
  dynamic shopRating;

  OrderH({
    this.id,
    this.shopId,
    this.userId,
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
    this.shop,
    this.car,
    this.orderItems,
    this.shopRating,
    this.paymentMethod,
  });

  @override
  String toString() {
    return 'OrderH(id: $id, shopId: $shopId, userId: $userId, amount: $amount, womEarning: $womEarning, shopEarning: $shopEarning, couponAmount: $couponAmount, payableAmount: $payableAmount, pointsAmount: $pointsAmount, pointsEarned: $pointsEarned, pointsUsed: $pointsUsed, vatAmount: $vatAmount, orderStatus: $orderStatus, orderType: $orderType, paymentStatus: $paymentStatus, couponCode: $couponCode, remarks: $remarks, carId: $carId, lastUpdatedBy: $lastUpdatedBy, paymentReference: $paymentReference, estimatedTime: $estimatedTime, createdAt: $createdAt, updatedAt: $updatedAt, shop: $shop, car: $car, orderItems: $orderItems, shopRating: $shopRating, paymentMethod: $paymentMethod)';
  }

  factory OrderH.fromJson(Map<String, dynamic> json) => OrderH(
        id: json['id'] as int?,
        shopId: json['shop_id'] as dynamic,
        userId: json['user_id'] as int?,
        amount: json['amount'] != null ? json['amount'].toString() : "",
        womEarning: json['wom_earning'].toString(),
        shopEarning: json['shop_earning'].toString(),
        couponAmount: json['coupon_amount'].toString(),
        payableAmount: json['payable_amount'].toString(),
        pointsAmount: json['points_amount'].toString(),
        pointsEarned: json['points_earned'].toString(),
        pointsUsed: json['points_used'].toString(),
        vatAmount: json['vat_amount'].toString(),
        orderStatus: json['order_status'].toString(),
        orderType: json['order_type'].toString(),
        paymentStatus: json['payment_status'].toString(),
        couponCode: json['coupon_code'] as dynamic,
        remarks: json['remarks'] as dynamic,
        carId: json['car_id'] as dynamic,
        lastUpdatedBy: json['last_updated_by'] as dynamic,
        paymentReference: json['payment_reference'] as dynamic,
        paymentMethod: json['payment_method'] as dynamic,
        estimatedTime: json['estimated_time'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        shop: json['shop'] as dynamic,
        car: json['car'] as dynamic,
        orderItems: (json['order_items'] as List<dynamic>?)
            ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        shopRating: json['shop_rating'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'shop_id': shopId,
        'user_id': userId,
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
        'payment_method': paymentMethod,
        'coupon_code': couponCode,
        'remarks': remarks,
        'car_id': carId,
        'last_updated_by': lastUpdatedBy,
        'payment_reference': paymentReference,
        'estimated_time': estimatedTime,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'shop': shop,
        'car': car,
        'order_items': orderItems?.map((e) => e.toJson()).toList(),
        'shop_rating': shopRating,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderH) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      shopId.hashCode ^
      userId.hashCode ^
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
      paymentMethod.hashCode ^
      couponCode.hashCode ^
      remarks.hashCode ^
      carId.hashCode ^
      lastUpdatedBy.hashCode ^
      paymentReference.hashCode ^
      estimatedTime.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      shop.hashCode ^
      car.hashCode ^
      orderItems.hashCode ^
      shopRating.hashCode;
}
