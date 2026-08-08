// domain/params/add_to_cart_params.dart
class AddToCartParams {
  final int productId;
  final int variantId;
  final int quantity;

  AddToCartParams({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'variant_id': variantId,
    'quantity': quantity,
  };
}
