import '../entities/cart/feed_add_cart_params_model.dart';
import '../entities/cart/feed_cart_model.dart';
import '../repositories/cart_repo.dart';

class AddToCartUseCase {
  final CartRepository repository;
  AddToCartUseCase(this.repository);

  Future<void> call(AddToCartParams params) {
    return repository.addToCart(params);
  }
}

class IncrementQuantityUseCase {
  final CartRepository repository;
  IncrementQuantityUseCase(this.repository);
  Future<void> call(int cartItemId) => repository.incrementQuantity(cartItemId);
}

class DecrementQuantityUseCase {
  final CartRepository repository;
  DecrementQuantityUseCase(this.repository);
  Future<void> call(int cartItemId) => repository.decrementQuantity(cartItemId);
}

class RemoveFromCartUseCase {
  final CartRepository repository;
  RemoveFromCartUseCase(this.repository);
  Future<void> call(int cartItemId) => repository.removeFromCart(cartItemId);
}

class GetCartUseCase {
  final CartRepository repository;
  GetCartUseCase(this.repository);

  Future<FeedCartResponseModel> call() {
    return repository.getCart();
  }
}

class GetCartCountUseCase {
  final CartRepository repository;
  GetCartCountUseCase(this.repository);

  Future<int> call() {
    return repository.getCartCount();
  }
}

class ClearCartUseCase {
  final CartRepository repository;
  ClearCartUseCase(this.repository);
  Future<void> call() => repository.clearCart();
}

class AddPastOrdersUseCase {
  final CartRepository repository;
  AddPastOrdersUseCase(this.repository);
  Future<List<FeedCartItemModel>> call(int orderId) =>
      repository.addPastOrders(orderId);
}
