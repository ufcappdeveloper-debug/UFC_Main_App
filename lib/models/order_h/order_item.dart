import 'package:collection/collection.dart';

import 'product.dart';

class OrderItem {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  String? orderPrice;
  String? variationPrice;
  int? variationId;
  dynamic variationName;
  dynamic size;
  dynamic remarks;
  DateTime? createdAt;
  DateTime? updatedAt;
  Product? product;

  OrderItem({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.orderPrice,
    this.variationPrice,
    this.variationId,
    this.variationName,
    this.size,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  @override
  String toString() {
    return 'OrderItem(id: $id, orderId: $orderId, productId: $productId, quantity: $quantity, orderPrice: $orderPrice, variationPrice: $variationPrice, variationId: $variationId, variationName: $variationName, size: $size, remarks: $remarks, createdAt: $createdAt, updatedAt: $updatedAt, product: $product)';
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'] as int?,
        orderId: json['order_id'] as int?,
        productId: json['product_id'] as int?,
        quantity: json['quantity'] as int?,
        orderPrice: json['order_price'].toString(),
        variationPrice: json['variation_price'].toString(),
        variationId: json['variation_id'] as int?,
        variationName: json['variation_name'] as dynamic,
        size: json['size'] as dynamic,
        remarks: json['remarks'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        product: json['product'] == null
            ? null
            : Product.fromJson(json['product'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'product_id': productId,
        'quantity': quantity,
        'order_price': orderPrice,
        'variation_price': variationPrice,
        'variation_id': variationId,
        'variation_name': variationName,
        'size': size,
        'remarks': remarks,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'product': product?.toJson(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderItem) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      orderId.hashCode ^
      productId.hashCode ^
      quantity.hashCode ^
      orderPrice.hashCode ^
      variationPrice.hashCode ^
      variationId.hashCode ^
      variationName.hashCode ^
      size.hashCode ^
      remarks.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      product.hashCode;
}
