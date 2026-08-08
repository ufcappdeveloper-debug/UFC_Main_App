import 'order_item.dart';

class OrderHistoryModel {
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

  OrderHistoryModel({
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
  });

  @override
  String toString() {
    return 'OrderHistoryModel(id: $id, shopId: $shopId, userId: $userId, amount: $amount, womEarning: $womEarning, shopEarning: $shopEarning, couponAmount: $couponAmount, payableAmount: $payableAmount, pointsAmount: $pointsAmount, pointsEarned: $pointsEarned, pointsUsed: $pointsUsed, vatAmount: $vatAmount, orderStatus: $orderStatus, orderType: $orderType, paymentStatus: $paymentStatus, couponCode: $couponCode, remarks: $remarks, carId: $carId, lastUpdatedBy: $lastUpdatedBy, paymentReference: $paymentReference, estimatedTime: $estimatedTime, createdAt: $createdAt, updatedAt: $updatedAt, shop: $shop, car: $car, orderItems: $orderItems, shopRating: $shopRating)';
  }

  OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    userId = json['user_id'];
    amount = json['amount'];
    womEarning = json['wom_earning'];
    shopEarning = json['shop_earning'];
    couponAmount = json['coupon_amount'];
    payableAmount = json['payable_amount'];
    pointsAmount = json['points_amount'];
    pointsEarned = json['points_earned'];
    pointsUsed = json['points_used'];
    vatAmount = json['vat_amount'];
    orderStatus = json['order_status'];
    orderType = json['order_type'];
    paymentStatus = json['payment_status'];
    couponCode = json['coupon_code'];
    remarks = json['remarks'];
    carId = json['car_id'];
    lastUpdatedBy = json['last_updated_by'];
    paymentReference = json['payment_reference'];
    estimatedTime = json['estimated_time'];
    createdAt = json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String);
    updatedAt = json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String);
    shop = json['shop'];
    car = json['car'];
    if (json['order_items'] != null) {
      orderItems = <OrderItem>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItem.fromJson(v));
      });
    }
    shopRating = json['shop_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['wom_earning'] = womEarning;
    data['shop_earning'] = shopEarning;
    data['coupon_amount'] = couponAmount;
    data['payable_amount'] = payableAmount;
    data['points_amount'] = pointsAmount;
    data['points_earned'] = pointsEarned;
    data['points_used'] = pointsUsed;
    data['vat_amount'] = vatAmount;
    data['order_status'] = orderStatus;
    data['order_type'] = orderType;
    data['payment_status'] = paymentStatus;
    data['coupon_code'] = couponCode;
    data['remarks'] = remarks;
    data['car_id'] = carId;
    data['last_updated_by'] = lastUpdatedBy;
    data['payment_reference'] = paymentReference;
    data['estimated_time'] = estimatedTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['shop'] = shop;
    data['car'] = car;
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    data['shop_rating'] = shopRating;
    return data;
  }
}

// factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
//     OrderHistoryModel(
//       id: json['id'] as int?,
//       shopId: json['shop_id'] as dynamic,
//       userId: json['user_id'] as int?,
//       amount: json['amount'] as String?,
//       womEarning: json['wom_earning'] as String?,
//       shopEarning: json['shop_earning'] as String?,
//       couponAmount: json['coupon_amount'] as String?,
//       payableAmount: json['payable_amount'] as String?,
//       pointsAmount: json['points_amount'] as String?,
//       pointsEarned: json['points_earned'] as String?,
//       pointsUsed: json['points_used'] as String?,
//       vatAmount: json['vat_amount'] as String?,
//       orderStatus: json['order_status'] as String?,
//       orderType: json['order_type'] as String?,
//       paymentStatus: json['payment_status'] as String?,
//       couponCode: json['coupon_code'] as dynamic,
//       remarks: json['remarks'] as dynamic,
//       carId: json['car_id'] as dynamic,
//       lastUpdatedBy: json['last_updated_by'] as dynamic,
//       paymentReference: json['payment_reference'] as dynamic,
//       estimatedTime: json['estimated_time'] as dynamic,
//       createdAt: json['created_at'] == null
//           ? null
//           : DateTime.parse(json['created_at'] as String),
//       updatedAt: json['updated_at'] == null
//           ? null
//           : DateTime.parse(json['updated_at'] as String),
//       shop: json['shop'] as dynamic,
//       car: json['car'] as dynamic,
//       orderItems: json['order_items'] != null
//           ? json['order_items']
//               .map((dynamic item) =>
//                   OrderItem.fromJson(item as Map<String, dynamic>))
//               .toList()
//           : [],
//       // json['order_items'] as List<OrderItem>,
//       shopRating: json['shop_rating'] as dynamic,

//       // final List<dynamic>? rawOrderItems = json['order_items'];
//       // List<OrderItem>? orderItems;

//       // if (rawOrderItems != null) {
//       //   orderItems = rawOrderItems
//       //       .map((dynamic item) => OrderItem.fromJson(item as Map<String, dynamic>))
//       //       .toList();
//       // }
//     );

// Map<String, dynamic> toJson() => {
//       'id': id,
//       'shop_id': shopId,
//       'user_id': userId,
//       'amount': amount,
//       'wom_earning': womEarning,
//       'shop_earning': shopEarning,
//       'coupon_amount': couponAmount,
//       'payable_amount': payableAmount,
//       'points_amount': pointsAmount,
//       'points_earned': pointsEarned,
//       'points_used': pointsUsed,
//       'vat_amount': vatAmount,
//       'order_status': orderStatus,
//       'order_type': orderType,
//       'payment_status': paymentStatus,
//       'coupon_code': couponCode,
//       'remarks': remarks,
//       'car_id': carId,
//       'last_updated_by': lastUpdatedBy,
//       'payment_reference': paymentReference,
//       'estimated_time': estimatedTime,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//       'shop': shop,
//       'car': car,
//       'order_items': orderItems,
//       'shop_rating': shopRating,
//     };

// @override
// bool operator ==(Object other) {
//   if (identical(other, this)) return true;
//   if (other is! OrderHistoryModel) return false;
//   final mapEquals = const DeepCollectionEquality().equals;
//   return mapEquals(other.toJson(), toJson());
// }

// @override
// int get hashCode =>
//     id.hashCode ^
//     shopId.hashCode ^
//     userId.hashCode ^
//     amount.hashCode ^
//     womEarning.hashCode ^
//     shopEarning.hashCode ^
//     couponAmount.hashCode ^
//     payableAmount.hashCode ^
//     pointsAmount.hashCode ^
//     pointsEarned.hashCode ^
//     pointsUsed.hashCode ^
//     vatAmount.hashCode ^
//     orderStatus.hashCode ^
//     orderType.hashCode ^
//     paymentStatus.hashCode ^
//     couponCode.hashCode ^
//     remarks.hashCode ^
//     carId.hashCode ^
//     lastUpdatedBy.hashCode ^
//     paymentReference.hashCode ^
//     estimatedTime.hashCode ^
//     createdAt.hashCode ^
//     updatedAt.hashCode ^
//     shop.hashCode ^
//     car.hashCode ^
//     orderItems.hashCode ^
//     shopRating.hashCode;
//}
