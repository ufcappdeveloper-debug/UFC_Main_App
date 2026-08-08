import 'package:collection/collection.dart';

class DeliveryOrderSummary {
  String? status;
  OrderData? data;

  DeliveryOrderSummary({
    this.status,
    this.data,
  });

  factory DeliveryOrderSummary.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderSummary(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : OrderData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.toJson(),
      };

  @override
  String toString() => 'OrderDetails(status: $status, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! DeliveryOrderSummary) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode;
}

class OrderData {
  int? orderId;
  String? customerName;
  String? from;
  String? fromAr;
  String? to;
  String? createdAt;
  String? estimatedDeliveryDate;
  Driver? driver;

  List<StatusChange>? statusChanges;

  OrderData({
    this.orderId,
    this.customerName,
    this.from,
    this.fromAr,
    this.to,
    this.createdAt,
    this.estimatedDeliveryDate,
    this.driver,
    this.statusChanges,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderId: json['order_id'] as int?,
      customerName: json['customer_name'] as String?,
      from: json['from'] as String?,
      fromAr: json['from_ar'] as String?,
      to: json['to'] as String?,
      createdAt: json['created_at'] as String?,
      estimatedDeliveryDate: json['estimated_delivery_date'] as String?,
      driver: json['driver'] == null
          ? null
          : Driver.fromJson(json['driver'] as Map<String, dynamic>),
      statusChanges: (json['status_changes'] as List<dynamic>?)
          ?.map((e) => StatusChange.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'customer_name': customerName,
        'from': from,
        'from_ar': fromAr,
        'to': to,
        'created_at': createdAt,
        'estimated_delivery_date': estimatedDeliveryDate,
        'driver': driver?.toJson(),
        'status_changes': statusChanges?.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    return 'OrderData(orderId: $orderId, customerName: $customerName, from: $from, to: $to, createdAt: $createdAt, estimatedDeliveryDate: $estimatedDeliveryDate, driver: $driver, statusChanges: $statusChanges)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderData) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      orderId.hashCode ^
      customerName.hashCode ^
      from.hashCode ^
      to.hashCode ^
      createdAt.hashCode ^
      estimatedDeliveryDate.hashCode ^
      driver.hashCode ^
      statusChanges.hashCode;
}

class Driver {
  String? name;
  String? photo;
  String? phone;

  Driver({
    this.name,
    this.photo,
    this.phone,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'photo': photo,
        'phone': phone,
      };

  @override
  String toString() => 'Driver(name: $name, photo: $photo, phone: $phone)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Driver) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => name.hashCode ^ photo.hashCode ^ phone.hashCode;
}

class StatusChange {
  String? description;
  String? createdAt;

  StatusChange({
    this.description,
    this.createdAt,
  });

  factory StatusChange.fromJson(Map<String, dynamic> json) {
    return StatusChange(
      description: json['description'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'created_at': createdAt,
      };

  @override
  String toString() =>
      'StatusChange(description: $description, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! StatusChange) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => description.hashCode ^ createdAt.hashCode;
}
