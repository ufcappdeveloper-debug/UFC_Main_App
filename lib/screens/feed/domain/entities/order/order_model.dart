import 'package:collection/collection.dart';
import 'package:ufc_mobile/global/util/extension/string_extensions.dart';
import 'package:ufc_mobile/models/order_summary_model/user_address.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';

import '../../../../../models/order_hh/go_pay.dart';
import '../../../../../models/order_hh/order_delivery_status.dart';
import '../../../../../models/order_hh/order_item.dart';
import '../../../../../models/order_hh/shop.dart';
import '../../../presentation/distributor/utils/distributor_style.dart';
import '../distributor/bank_transfer_model.dart';
import '../distributor/distributor_model.dart';

class OrderModel {
  int? id;
  int? shopId;
  int? userId;
  dynamic addressId;
  double? amount;
  double? womEarning;
  double? shopEarning;
  double? couponAmount;
  double? payableAmount;
  double? pointsAmount;
  double? pointsEarned;
  double? pointsUsed;
  double? vatAmount;
  double? totalWithVat;
  double? deliveryFee;
  double? deliveryVat;
  String? orderStatus;
  String? orderType;
  String? paymentStatus;
  String? paymentMethod;
  dynamic couponCode;
  String? voucherCode;
  double? voucherDiscount;
  String? deliveryCouponCode;
  double? deliveryCouponAmount;
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
  GoPay? goPay;
  Shop? shop;
  UserModel? user;
  List<OrderDeliveryStatus>? orderDeliveryStatus;
  UserAddress? userAddress;
  List<OrderItem>? orderItems;
  dynamic car;
  dynamic shopRating;
  String? note;
  String? bookingDateTime;

  /// "SHOP" or "DISTRIBUTOR" (older orders read back as "SHOP").
  String? channel;
  int? distributorId;
  DistributorModel? distributor;
  String? stationName;

  /// Present while a BANK distributor order is unpaid; null once paid.
  BankTransferModel? bankTransfer;

  /// Temporary signed link (60 minutes): re-read it from the API, don't store.
  String? bankReceiptUrl;

  /// ISO 8601 on the orders list, `Y-m-d H:i` (UTC) on order details.
  String? bankReceiptUploadedAt;

  bool get isDistributor => channel == 'DISTRIBUTOR' || (shop == null && distributor != null);

  bool get isBankDistributorOrder =>
      isDistributor && paymentMethod == 'BANK';

  bool get isClosedOrder =>
      orderStatus == 'CANCELLED' || orderStatus == 'REJECTED';

  /// The customer can upload (or replace) the transfer receipt.
  bool get canUploadBankReceipt =>
      isBankDistributorOrder && paymentStatus == 'PENDING' && !isClosedOrder;

  bool get hasBankReceipt => bankReceiptUrl?.isNotEmpty ?? false;

  String get vendorName {
    if (shop != null) return localized(shop?.nameEn, shop?.nameAr);
    if (distributor != null) return distributor!.name;
    return stationName ?? '';
  }

  OrderModel({
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
    this.totalWithVat,
    this.deliveryFee,
    this.deliveryVat,
    this.orderStatus,
    this.orderType,
    this.paymentStatus,
    this.paymentMethod,
    this.couponCode,
    this.voucherCode,
    this.voucherDiscount,
    this.deliveryCouponCode,
    this.deliveryCouponAmount,
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
    this.goPay,
    this.shop,
    this.user,
    this.orderDeliveryStatus,
    this.userAddress,
    this.orderItems,
    this.car,
    this.shopRating,
    this.note,
    this.bookingDateTime,
    this.channel,
    this.distributorId,
    this.distributor,
    this.stationName,
    this.bankTransfer,
    this.bankReceiptUrl,
    this.bankReceiptUploadedAt,
  });

  @override
  String toString() {
    return 'OrderModel(id: $id, shopId: $shopId, userId: $userId, addressId: $addressId, amount: $amount, womEarning: $womEarning, shopEarning: $shopEarning, couponAmount: $couponAmount, payableAmount: $payableAmount, pointsAmount: $pointsAmount, pointsEarned: $pointsEarned, pointsUsed: $pointsUsed, vatAmount: $vatAmount, orderStatus: $orderStatus, orderType: $orderType, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, couponCode: $couponCode, remarks: $remarks, carId: $carId, lastUpdatedBy: $lastUpdatedBy, paymentReference: $paymentReference, estimatedTime: $estimatedTime, driverName: $driverName, driverPlate: $driverPlate, driverPhoneNumber: $driverPhoneNumber, createdAt: $createdAt, updatedAt: $updatedAt, goPay: $goPay, shop: $shop, user: $user, orderDeliveryStatus: $orderDeliveryStatus, userAddress: $userAddress, orderItems: $orderItems, car: $car, shopRating: $shopRating, note: $note, bookingDateTime: $bookingDateTime)';
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as int?,
        shopId: json['shop_id'] as int?,
        userId: json['user_id'] as int?,
        addressId: json['address_id'] as dynamic,
        amount: json['amount']?.toString().toTryDouble() ?? 0.0,
        womEarning: json['wom_earning']?.toString().toTryDouble() ?? 0.0,
        shopEarning: json['shop_earning']?.toString().toTryDouble() ?? 0.0,
        couponAmount: json['coupon_amount']?.toString().toTryDouble() ?? 0.0,
        payableAmount: json['payable_amount']?.toString().toTryDouble() ?? 0.0,
        pointsAmount: json['points_amount']?.toString().toTryDouble() ?? 0.0,
        pointsEarned: json['points_earned']?.toString().toTryDouble() ?? 0.0,
        pointsUsed: json['points_used']?.toString().toTryDouble() ?? 0.0,
        vatAmount: json['vat_amount']?.toString().toTryDouble() ?? 0.0,
        totalWithVat: json['total_with_vat']?.toString().toTryDouble() ?? 0.0,
        deliveryFee: json['delivery_fee']?.toString().toTryDouble() ?? 0.0,
        deliveryVat: json['delivery_vat']?.toString().toTryDouble() ?? 0.0,
        orderStatus: json['order_status'] as String?,
        orderType: json['order_type'] as String?,
        paymentStatus: json['payment_status'] as String?,
        paymentMethod: json['payment_method'] as String?,
        couponCode: json['coupon_code'] as dynamic,
        voucherCode: json['voucher_code']?.toString(),
        voucherDiscount:
            json['voucher_discount']?.toString().toTryDouble() ?? 0.0,
        deliveryCouponCode: json['delivery_coupon_code']?.toString(),
        deliveryCouponAmount:
            json['delivery_coupon_amount']?.toString().toTryDouble() ?? 0.0,
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
            : DateTime.parse(json['created_at'] as String).toLocal(),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        goPay: json['go_pay'] == null
            ? null
            : GoPay.fromJson(json['go_pay'] as Map<String, dynamic>),
        shop: json['shop'] == null
            ? null
            : Shop.fromJson(json['shop'] as Map<String, dynamic>),
        user: json['user'] == null
            ? null
            : UserModel.fromJson(json['user'] as Map<String, dynamic>),
        orderDeliveryStatus: (json['order_delivery_status'] as List<dynamic>?)
            ?.map(
                (e) => OrderDeliveryStatus.fromJson(e as Map<String, dynamic>))
            .toList(),
        userAddress: json['user_address'] == null
            ? null
            : UserAddress.fromJson(json['user_address'] as Map<String, dynamic>),
        
       
        orderItems: (json['order_items'] as List<dynamic>?)
            ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        car: json['car'] as dynamic,
        shopRating: json['shop_rating'] as dynamic,
        note: json['note'] as String?,
        bookingDateTime: json['booking_date_time'] as String?,
        channel: json['channel']?.toString() ?? 'SHOP',
        distributorId: json['distributor_id'] as int?,
        distributor: json['distributor'] is Map<String, dynamic>
            ? DistributorModel.fromJson(json['distributor'])
            : null,
        stationName: json['station_name']?.toString(),
        bankTransfer: BankTransferModel.tryParse(json['bank_transfer']),
        bankReceiptUrl: json['bank_receipt_url']?.toString(),
        bankReceiptUploadedAt: json['bank_receipt_uploaded_at']?.toString(),
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
        'total_with_vat': totalWithVat,
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
        'go_pay': goPay?.toJson(),
        'shop': shop?.toJson(),
        'user': user?.toJson(),
        'order_delivery_status':
            orderDeliveryStatus?.map((e) => e.toJson()).toList(),
        'user_address': userAddress,
        'order_items': orderItems?.map((e) => e.toJson()).toList(),
        'car': car,
        'shop_rating': shopRating,
        'note': note,
        'booking_date_time': bookingDateTime,
        'channel': channel,
        'distributor_id': distributorId,
        'station_name': stationName,
        'bank_transfer': bankTransfer?.toJson(),
        'bank_receipt_url': bankReceiptUrl,
        'bank_receipt_uploaded_at': bankReceiptUploadedAt,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderModel) return false;
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
      goPay.hashCode ^
      shop.hashCode ^
      user.hashCode ^
      orderDeliveryStatus.hashCode ^
      userAddress.hashCode ^
      orderItems.hashCode ^
      car.hashCode ^
      shopRating.hashCode ^
      note.hashCode ^
      bookingDateTime.hashCode;
}
