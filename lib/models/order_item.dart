import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

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
  ProductModel? product;

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

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    orderPrice = json['order_price'];
    variationPrice = json['variation_price'];
    variationId = json['variation_id'];
    variationName = json['variation_name'];
    size = json['size'];
    remarks = json['remarks'];
    createdAt = json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String);
    updatedAt = json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String);
    product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['order_price'] = orderPrice;
    data['variation_price'] = variationPrice;
    data['variation_id'] = variationId;
    data['variation_name'] = variationName;
    data['size'] = size;
    data['remarks'] = remarks;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

///}
