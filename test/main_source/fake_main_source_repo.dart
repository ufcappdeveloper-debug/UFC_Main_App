import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/business_config_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_cart_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_order_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_payment_models.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_product_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/main_source/main_source_quote_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/main_source_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/distributor/distributor_data_source.dart'
    show Paginated;

/// Hand-written fake (no mocking package in the project): each test sets
/// the callbacks it needs; any other call fails the test.
class FakeMainSourceRepository extends Fake implements MainSourceRepository {
  final List<String> calls = [];

  Future<BusinessConfigModel> Function()? onGetBusinessConfig;
  Future<Paginated<MainSourceProductModel>> Function(MainSourceProductParams)?
      onGetProducts;
  Future<MainSourceCartModel> Function()? onGetCart;
  Future<MainSourceCartModel> Function(int variantId, int qty, bool replace)?
      onAddToCart;
  Future<MainSourceCartModel> Function(int id, int qty)? onUpdateCartItem;
  Future<MainSourceQuoteModel> Function(MainSourceCheckoutParams)? onQuote;
  Future<MainSourcePlaceOrderResult> Function(MainSourceCheckoutParams)?
      onPlaceOrder;
  Future<MainSourceOrderModel> Function(int id)? onGetOrder;
  Future<MainSourceOrderModel> Function(int id, String? reason)? onCancel;
  Future<MainSourceOrderModel> Function(
      int id, MainSourceBankTransferParams params)? onUploadBankTransfer;
  Future<MainSourcePaymentVerifyResult> Function(String checkoutId)? onVerify;

  @override
  Future<BusinessConfigModel> getBusinessConfig() {
    calls.add('getBusinessConfig');
    return onGetBusinessConfig!();
  }

  @override
  Future<Paginated<MainSourceProductModel>> getProducts(
      MainSourceProductParams params) {
    calls.add('getProducts:${params.page}');
    return onGetProducts!(params);
  }

  @override
  Future<MainSourceCartModel> getCart() {
    calls.add('getCart');
    return onGetCart!();
  }

  @override
  Future<MainSourceCartModel> addToCart(
      {required int variantId, int quantity = 1, bool replaceCart = false}) {
    calls.add('addToCart:$variantId:$quantity:$replaceCart');
    return onAddToCart!(variantId, quantity, replaceCart);
  }

  @override
  Future<MainSourceCartModel> updateCartItem(int cartItemId, int quantity) {
    calls.add('updateCartItem:$cartItemId:$quantity');
    return onUpdateCartItem!(cartItemId, quantity);
  }

  @override
  Future<MainSourceQuoteModel> quote(MainSourceCheckoutParams params) {
    calls.add('quote');
    return onQuote!(params);
  }

  @override
  Future<MainSourcePlaceOrderResult> placeOrder(
      MainSourceCheckoutParams params) {
    calls.add('placeOrder:${params.force}');
    return onPlaceOrder!(params);
  }

  @override
  Future<MainSourceOrderModel> getOrder(int id) {
    calls.add('getOrder:$id');
    return onGetOrder!(id);
  }

  @override
  Future<MainSourceOrderModel> cancelOrder(int id, {String? reason}) {
    calls.add('cancelOrder:$id');
    return onCancel!(id, reason);
  }

  @override
  Future<MainSourceOrderModel> uploadBankTransfer(
      int orderId, MainSourceBankTransferParams params,
      {void Function(int sent, int total)? onProgress}) {
    calls.add('uploadBankTransfer:$orderId');
    onProgress?.call(50, 100);
    return onUploadBankTransfer!(orderId, params);
  }

  @override
  Future<MainSourcePaymentVerifyResult> verifyPayment(String checkoutId) {
    calls.add('verify:$checkoutId');
    return onVerify!(checkoutId);
  }
}
