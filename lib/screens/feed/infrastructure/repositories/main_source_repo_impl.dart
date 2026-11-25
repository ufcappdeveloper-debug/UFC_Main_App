import '../../domain/entities/main_source/business_config_model.dart';
import '../../domain/entities/main_source/main_source_cart_model.dart';
import '../../domain/entities/main_source/main_source_model.dart';
import '../../domain/entities/main_source/main_source_order_model.dart';
import '../../domain/entities/main_source/main_source_params.dart';
import '../../domain/entities/main_source/main_source_payment_models.dart';
import '../../domain/entities/main_source/main_source_product_model.dart';
import '../../domain/entities/main_source/main_source_quote_model.dart';
import '../../domain/repositories/main_source_repo.dart';
import '../data_sources/distributor/distributor_data_source.dart' show Paginated;
import '../data_sources/main_source/main_source_data_source.dart';

class MainSourceRepositoryImpl implements MainSourceRepository {
  final MainSourceRemoteDataSource remote;

  MainSourceRepositoryImpl(this.remote);

  @override
  Future<BusinessConfigModel> getBusinessConfig() => remote.getBusinessConfig();

  @override
  Future<MainSourceHomeModel> getHome({int productsLimit = 10}) =>
      remote.getHome(productsLimit: productsLimit);

  @override
  Future<List<MainSourceModel>> getMainSources() => remote.getMainSources();

  @override
  Future<List<MainSourceCategoryModel>> getCategories({int? mainSourceId}) =>
      remote.getCategories(mainSourceId: mainSourceId);

  @override
  Future<Paginated<MainSourceProductModel>> getProducts(
          MainSourceProductParams params) =>
      remote.getProducts(params);

  @override
  Future<MainSourceProductModel> getProduct(int id) => remote.getProduct(id);

  @override
  Future<MainSourceCartModel> getCart() => remote.getCart();

  @override
  Future<MainSourceCartCount> getCartCount() => remote.getCartCount();

  @override
  Future<MainSourceCartModel> addToCart(
          {required int variantId,
          int quantity = 1,
          bool replaceCart = false}) =>
      remote.addToCart(
          variantId: variantId, quantity: quantity, replaceCart: replaceCart);

  @override
  Future<MainSourceCartModel> updateCartItem(int cartItemId, int quantity) =>
      remote.updateCartItem(cartItemId, quantity);

  @override
  Future<MainSourceCartModel> removeCartItem(int cartItemId) =>
      remote.removeCartItem(cartItemId);

  @override
  Future<MainSourceCartModel> clearCart() => remote.clearCart();

  @override
  Future<MainSourceQuoteModel> quote(MainSourceCheckoutParams params) =>
      remote.quote(params);

  @override
  Future<MainSourcePlaceOrderResult> placeOrder(
          MainSourceCheckoutParams params) =>
      remote.placeOrder(params);

  @override
  Future<MainSourcePaymentVerifyResult> verifyPayment(String checkoutId) =>
      remote.verifyPayment(checkoutId);

  @override
  Future<MainSourcePayStartResult> payOrder(int orderId) =>
      remote.payOrder(orderId);

  @override
  Future<Paginated<MainSourceOrderModel>> getOrders(
          {int page = 1, int limit = 15, List<String>? statuses}) =>
      remote.getOrders(page: page, limit: limit, statuses: statuses);

  @override
  Future<MainSourceOrderModel> getOrder(int id) => remote.getOrder(id);

  @override
  Future<MainSourceOrderModel> cancelOrder(int id, {String? reason}) =>
      remote.cancelOrder(id, reason: reason);

  @override
  Future<MainSourceReorderResult> reorder(int id) => remote.reorder(id);

  @override
  Future<void> downloadInvoice(int id, String savePath) =>
      remote.downloadInvoice(id, savePath);

  @override
  Future<MainSourceOrderModel> uploadBankTransfer(
          int orderId, MainSourceBankTransferParams params,
          {void Function(int sent, int total)? onProgress}) =>
      remote.uploadBankTransfer(orderId, params, onProgress: onProgress);
}
