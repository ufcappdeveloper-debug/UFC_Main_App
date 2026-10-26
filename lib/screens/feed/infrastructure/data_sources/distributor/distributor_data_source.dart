import '../../../domain/entities/distributor/checkout_options_model.dart';
import '../../../domain/entities/distributor/checkout_summary_model.dart';
import '../../../domain/entities/distributor/distributor_cart_model.dart';
import '../../../domain/entities/distributor/distributor_category_model.dart';
import '../../../domain/entities/distributor/distributor_model.dart';
import '../../../domain/entities/distributor/distributor_place_order_result.dart';
import '../../../domain/entities/distributor/distributor_product_model.dart';
import '../../../domain/entities/distributor/distributor_query_params.dart';

class Paginated<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const Paginated({
    this.items = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  bool get hasMore => currentPage < lastPage;
}

abstract class DistributorRemoteDataSource {
  // Browsing (A.1 – A.3)
  Future<Paginated<DistributorModel>> getDistributors(
      DistributorListParams params);
  Future<DistributorModel> getDistributorDetail(int id);
  Future<List<DistributorCategoryModel>> getCategories(int distributorId);
  Future<Paginated<DistributorProductModel>> getProducts(
      DistributorProductParams params);
  Future<DistributorProductModel> getProduct(int id);

  // Cart (A.4)
  Future<void> addToCart(AddDistributorCartParams params);
  Future<DistributorCartModel> getCart();
  Future<int> getCartCount();
  Future<void> incrementQuantity(int cartItemId);
  Future<void> decrementQuantity(int cartItemId);
  Future<void> updateQuantity(int cartItemId, int quantity);
  Future<void> removeFromCart(int cartItemId);
  Future<void> clearCart();

  // Checkout (A.5 – A.7)
  Future<CheckoutOptionsModel> getCheckoutOptions(int distributorId);
  Future<DistributorCheckoutSummary> getCheckoutSummary({
    required String orderType,
    String? couponCode,
  });
  Future<DistributorPlaceOrderResult> placeOrder(
      DistributorPlaceOrderParams params);
  Future<PlaceOrderAgainResult> placeOrderAgain(int orderId);

  /// "Order Now": buys one product without the cart.
  Future<DistributorPlaceOrderResult> buyProduct(
      DistributorBuyProductParams params);

  // Favorites (A.9)
  Future<bool> toggleFavorite(int productId);
  Future<Paginated<DistributorProductModel>> getFavorites(int page);
}
