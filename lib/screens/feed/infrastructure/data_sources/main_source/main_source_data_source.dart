import '../../../domain/entities/main_source/business_config_model.dart';
import '../../../domain/entities/main_source/main_source_cart_model.dart';
import '../../../domain/entities/main_source/main_source_model.dart';
import '../../../domain/entities/main_source/main_source_order_model.dart';
import '../../../domain/entities/main_source/main_source_params.dart';
import '../../../domain/entities/main_source/main_source_payment_models.dart';
import '../../../domain/entities/main_source/main_source_product_model.dart';
import '../../../domain/entities/main_source/main_source_quote_model.dart';
import '../distributor/distributor_data_source.dart' show Paginated;

/// Main Source endpoints (docs/MainSourceBusineessPlan-fixed-21-11-2026.md).
/// Every failure is a `MainSourceApiException`.
abstract class MainSourceRemoteDataSource {
  // 1. Launch
  Future<BusinessConfigModel> getBusinessConfig();

  // 2–6. Catalogue (public)
  Future<MainSourceHomeModel> getHome({int productsLimit = 10});
  Future<List<MainSourceModel>> getMainSources();
  Future<List<MainSourceCategoryModel>> getCategories({int? mainSourceId});
  Future<Paginated<MainSourceProductModel>> getProducts(
      MainSourceProductParams params);
  Future<MainSourceProductModel> getProduct(int id);

  // 7–12. Cart
  Future<MainSourceCartModel> getCart();
  Future<MainSourceCartCount> getCartCount();
  Future<MainSourceCartModel> addToCart(
      {required int variantId, int quantity = 1, bool replaceCart = false});
  Future<MainSourceCartModel> updateCartItem(int cartItemId, int quantity);
  Future<MainSourceCartModel> removeCartItem(int cartItemId);
  Future<MainSourceCartModel> clearCart();

  // 13–16. Checkout and payment
  Future<MainSourceQuoteModel> quote(MainSourceCheckoutParams params);
  Future<MainSourcePlaceOrderResult> placeOrder(
      MainSourceCheckoutParams params);
  Future<MainSourcePaymentVerifyResult> verifyPayment(String checkoutId);
  Future<MainSourcePayStartResult> payOrder(int orderId);

  // 17–21. Orders
  Future<Paginated<MainSourceOrderModel>> getOrders(
      {int page = 1, int limit = 15, List<String>? statuses});
  Future<MainSourceOrderModel> getOrder(int id);
  Future<MainSourceOrderModel> cancelOrder(int id, {String? reason});
  Future<MainSourceReorderResult> reorder(int id);

  /// Saves the order's PDF invoice to [savePath].
  Future<void> downloadInvoice(int id, String savePath);
  Future<MainSourceOrderModel> uploadBankTransfer(
      int orderId, MainSourceBankTransferParams params,
      {void Function(int sent, int total)? onProgress});
}
