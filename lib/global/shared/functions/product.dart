import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

// To verify whether a discount price exists or not
bool isDiscountPriceExist(ProductModel productData) {
  // Check if variants exist and are not empty
  if (productData.variants == null || productData.variants!.isEmpty) {
    return false;
  }

  // Check if originalPrice exists
  if (productData.variants?.first.originalPrice == null) return false;

  // Check if originalPrice is greater than price
  if ((productData.variants?.first.originalPrice ?? 0.0) <=
      (productData.variants?.first.price ?? 0.0)) {
    return false;
  }

  return true;
}
