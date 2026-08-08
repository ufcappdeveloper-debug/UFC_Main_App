import '../../domain/entities/cart/feed_add_cart_params_model.dart';
import '../../domain/entities/cart/feed_cart_model.dart';
import '../../domain/repositories/cart_repo.dart';
import '../data_sources/cart_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addToCart(AddToCartParams params) {
    return remoteDataSource.addToCart(params);
  }

  @override
  Future<FeedCartResponseModel> getCart() {
    return remoteDataSource.getCart();
  }

  @override
  Future<void> incrementQuantity(int cartItemId) {
    return remoteDataSource.incrementQuantity(cartItemId);
  }

  @override
  Future<void> decrementQuantity(int cartItemId) {
    return remoteDataSource.decrementQuantity(cartItemId);
  }

  @override
  Future<void> removeFromCart(int cartItemId) {
    return remoteDataSource.removeFromCart(cartItemId);
  }

  @override
  Future<int> getCartCount() {
    return remoteDataSource.getCartCount();
  }

  @override
  Future<void> clearCart() {
    return remoteDataSource.clearCart();
  }

  @override
  Future<List<FeedCartItemModel>> addPastOrders(int orderId) {
    return remoteDataSource.addPastOrders(orderId);
  }
}
