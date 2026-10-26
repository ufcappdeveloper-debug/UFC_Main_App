import 'package:collection/collection.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

class OrderItem {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  double? orderPrice;
  double? variationPrice;
  int? variationId;
  dynamic variationName;
  dynamic size;
  dynamic remarks;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductModel? product;

  /// "SHOP" or "DISTRIBUTOR". Distributor lines have `product == null` and
  /// carry `distributorProduct` instead.
  String? itemType;
  int? distributorProductId;
  int? distributorVariantId;
  ProductModel? distributorProduct;

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
    this.itemType,
    this.distributorProductId,
    this.distributorVariantId,
    this.distributorProduct,
  });

  bool get isDistributor => itemType == 'DISTRIBUTOR' ||
      (product == null && distributorProduct != null);

  /// Use this instead of [product] when rendering order lines.
  ProductModel? get displayProduct => product ?? distributorProduct;

  static ProductModel? _parseDistributorProduct(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    // Distributor categories/distributors are flat objects that don't match
    // the shop shapes ProductModel expects.
    return ProductModel.fromJson(
        Map<String, dynamic>.from(json)..remove('category')..remove('distributor'));
  }

  @override
  String toString() {
    return 'OrderItem(id: $id, orderId: $orderId, productId: $productId, quantity: $quantity, orderPrice: $orderPrice, variationPrice: $variationPrice, variationId: $variationId, variationName: $variationName, size: $size, remarks: $remarks, createdAt: $createdAt, updatedAt: $updatedAt, product: $product)';
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'] as int?,
        orderId: json['order_id'] as int?,
        productId: json['product_id'] as int?,
        quantity: json['quantity'] as int?,
        orderPrice: json['order_price'] != null
            ? double.parse(json['order_price'].toString())
            : 0.0,
        variationPrice: json['variation_price'] != null
            ? double.parse(json['variation_price'].toString())
            : null,

        // json['variation_price'] as int?,
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
            : ProductModel.fromJson(json['product'] as Map<String, dynamic>),
        itemType: json['item_type']?.toString(),
        distributorProductId: json['distributor_product_id'] as int?,
        distributorVariantId: json['distributor_variant_id'] as int?,
        distributorProduct: _parseDistributorProduct(json['distributor_product']),
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
        'item_type': itemType,
        'distributor_product_id': distributorProductId,
        'distributor_variant_id': distributorVariantId,
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
