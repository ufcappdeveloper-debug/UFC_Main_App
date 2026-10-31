import '../../domain/entities/distributor/bank_transfer_model.dart';
import '../../domain/entities/distributor/checkout_options_model.dart';
import '../../domain/entities/distributor/checkout_summary_model.dart';
import '../../domain/entities/distributor/distributor_cart_model.dart';
import '../../domain/entities/distributor/distributor_category_model.dart';
import '../../domain/entities/distributor/distributor_model.dart';
import '../../domain/entities/distributor/distributor_place_order_result.dart';
import '../../domain/entities/distributor/distributor_product_model.dart';
import '../../domain/entities/distributor/distributor_query_params.dart';
import '../../domain/repositories/distributor_repo.dart';
import '../data_sources/distributor/distributor_data_source.dart';

class DistributorRepositoryImpl implements DistributorRepository {
  final DistributorRemoteDataSource remote;

  DistributorRepositoryImpl(this.remote);

  @override
  Future<Paginated<DistributorModel>> getDistributors(
          DistributorListParams params) =>
      remote.getDistributors(params);

  @override
  Future<DistributorModel> getDistributorDetail(int id) =>
      remote.getDistributorDetail(id);

  @override
  Future<List<DistributorCategoryModel>> getCategories(int distributorId) =>
      remote.getCategories(distributorId);

  @override
  Future<Paginated<DistributorProductModel>> getProducts(
          DistributorProductParams params) =>
      remote.getProducts(params);

  @override
  Future<DistributorProductModel> getProduct(int id) => remote.getProduct(id);

  @override
  Future<void> addToCart(AddDistributorCartParams params) =>
      remote.addToCart(params);

  @override
  Future<DistributorCartModel> getCart() => remote.getCart();

  @override
  Future<int> getCartCount() => remote.getCartCount();

  @override
  Future<void> incrementQuantity(int cartItemId) =>
      remote.incrementQuantity(cartItemId);

  @override
  Future<void> decrementQuantity(int cartItemId) =>
      remote.decrementQuantity(cartItemId);

  @override
  Future<void> updateQuantity(int cartItemId, int quantity) =>
      remote.updateQuantity(cartItemId, quantity);

  @override
  Future<void> removeFromCart(int cartItemId) =>
      remote.removeFromCart(cartItemId);

  @override
  Future<void> clearCart() => remote.clearCart();

  @override
  Future<CheckoutOptionsModel> getCheckoutOptions(int distributorId) =>
      remote.getCheckoutOptions(distributorId);

  @override
  Future<DistributorCheckoutSummary> getCheckoutSummary(
          {required String orderType, String? couponCode}) =>
      remote.getCheckoutSummary(orderType: orderType, couponCode: couponCode);

  @override
  Future<DistributorPlaceOrderResult> placeOrder(
          DistributorPlaceOrderParams params) =>
      remote.placeOrder(params);

  @override
  Future<DistributorPlaceOrderResult> buyProduct(
          DistributorBuyProductParams params) =>
      remote.buyProduct(params);

  @override
  Future<BankReceiptModel> uploadBankReceipt(int orderId, String filePath,
          {void Function(int sent, int total)? onProgress}) =>
      remote.uploadBankReceipt(orderId, filePath, onProgress: onProgress);

  @override
  Future<String?> getBankReceiptUrl(int orderId) =>
      remote.getBankReceiptUrl(orderId);

  @override
  Future<PlaceOrderAgainResult> placeOrderAgain(int orderId) =>
      remote.placeOrderAgain(orderId);

  @override
  Future<bool> toggleFavorite(int productId) =>
      remote.toggleFavorite(productId);

  @override
  Future<Paginated<DistributorProductModel>> getFavorites(int page) =>
      remote.getFavorites(page);
}
