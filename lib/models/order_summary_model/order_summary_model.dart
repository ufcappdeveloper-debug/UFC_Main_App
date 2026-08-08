import 'package:collection/collection.dart';

import 'order_delivery_status.dart';
import 'order_item.dart';
import 'user.dart';
import 'user_address.dart';

class OrderSummaryModel {
  int? id;
  dynamic shopId;
  int? userId;
  int? addressId;
  int? amount;
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
  String? paymentMethod;
  dynamic couponCode;
  dynamic remarks;
  dynamic carId;
  dynamic lastUpdatedBy;
  dynamic paymentReference;
  dynamic estimatedTime;
  String? driverName;
  String? driverPlate;
  String? driverPhoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic shop;
  List<OrderItem>? orderItems;
  User? user;
  List<OrderDeliveryStatus>? orderDeliveryStatus;
  UserAddress? userAddress;

  OrderSummaryModel({
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
    this.paymentMethod,
    this.couponCode,
    this.remarks,
    this.carId,
    this.lastUpdatedBy,
    this.paymentReference,
    this.estimatedTime,
    this.driverName,
    this.driverPlate,
    this.driverPhoneNumber,
    this.createdAt,
    this.updatedAt,
    this.shop,
    this.orderItems,
    this.user,
    this.orderDeliveryStatus,
    this.userAddress,
  });

  @override
  String toString() {
    return 'OrderSummaryModel(id: $id, shopId: $shopId, userId: $userId, addressId: $addressId, amount: $amount, womEarning: $womEarning, shopEarning: $shopEarning, couponAmount: $couponAmount, payableAmount: $payableAmount, pointsAmount: $pointsAmount, pointsEarned: $pointsEarned, pointsUsed: $pointsUsed, vatAmount: $vatAmount, orderStatus: $orderStatus, orderType: $orderType, paymentStatus: $paymentStatus, couponCode: $couponCode, remarks: $remarks, carId: $carId, lastUpdatedBy: $lastUpdatedBy, paymentReference: $paymentReference, estimatedTime: $estimatedTime, createdAt: $createdAt, updatedAt: $updatedAt, shop: $shop, orderItems: $orderItems, user: $user, orderDeliveryStatus: $orderDeliveryStatus, userAddress: $userAddress)';
  }

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      id: json['id'] as int?,
      shopId: json['shop_id'] as dynamic,
      userId: json['user_id'] as int?,
      addressId: json['address_id'] as int?,
      amount: json['amount'].toInt(),
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
      paymentMethod: json['payment_method'] as String?,
      couponCode: json['coupon_code'] as dynamic,
      remarks: json['remarks'] as dynamic,
      carId: json['car_id'] as dynamic,
      lastUpdatedBy: json['last_updated_by'] as dynamic,
      paymentReference: json['payment_reference'] as dynamic,
      estimatedTime: json['estimated_time'] as dynamic,
      driverName: json['driver_name'] as String?,
      driverPlate: json['driver_plate'] as String?,
      driverPhoneNumber: json['driver_phone_number'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      shop: json['shop'] as dynamic,
      orderItems: (json['order_items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      orderDeliveryStatus: (json['order_delivery_status'] as List<dynamic>?)
          ?.map((e) => OrderDeliveryStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      userAddress: json['user_address'] == null
          ? null
          : UserAddress.fromJson(json['user_address'] as Map<String, dynamic>),
    );
  }

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
        'payment_method': paymentMethod,
        'coupon_code': couponCode,
        'remarks': remarks,
        'car_id': carId,
        'last_updated_by': lastUpdatedBy,
        'payment_reference': paymentReference,
        'estimated_time': estimatedTime,
        'driver_name': driverName,
        'driver_plate': driverPlate,
        'driver_phone_number': driverPhoneNumber,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'shop': shop,
        'order_items': orderItems?.map((e) => e.toJson()).toList(),
        'user': user?.toJson(),
        'order_delivery_status':
            orderDeliveryStatus?.map((e) => e.toJson()).toList(),
        'user_address': userAddress?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderSummaryModel) return false;
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
      orderItems.hashCode ^
      user.hashCode ^
      orderDeliveryStatus.hashCode ^
      userAddress.hashCode;
}
