// infrastructure/data_sources/cart_data_source.dart

import '../../domain/entities/cart/feed_add_cart_params_model.dart';
import '../../domain/entities/cart/feed_cart_model.dart';

abstract class CartRemoteDataSource {
  Future<void> addToCart(AddToCartParams params);
  Future<FeedCartResponseModel> getCart();
  Future<int> getCartCount();
  Future<void> incrementQuantity(int cartItemId);
  Future<void> decrementQuantity(int cartItemId);
  Future<void> removeFromCart(int cartItemId);
  Future<void> clearCart();
  Future<List<FeedCartItemModel>> addPastOrders(int orderId);
}
