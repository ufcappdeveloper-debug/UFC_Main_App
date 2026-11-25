import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../../domain/entities/main_source/business_config_model.dart';
import '../../../domain/entities/main_source/main_source_api_exception.dart';
import '../../../domain/entities/main_source/main_source_cart_model.dart';
import '../../../domain/entities/main_source/main_source_json.dart';
import '../../../domain/entities/main_source/main_source_model.dart';
import '../../../domain/entities/main_source/main_source_order_model.dart';
import '../../../domain/entities/main_source/main_source_params.dart';
import '../../../domain/entities/main_source/main_source_payment_models.dart';
import '../../../domain/entities/main_source/main_source_product_model.dart';
import '../../../domain/entities/main_source/main_source_quote_model.dart';
import '../distributor/distributor_data_source.dart' show Paginated;
import 'main_source_data_source.dart';

class MainSourceRemoteDataSourceImpl implements MainSourceRemoteDataSource {
  final Dio dio;

  MainSourceRemoteDataSourceImpl(this.dio);

  static const _base = '/api/ufc/v1';

  /// Runs [request] and turns API errors into [MainSourceApiException].
  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw toMainSourceException(e);
    }
  }

  /// Visible for tests.
  static MainSourceApiException toMainSourceException(DioException e) {
    final body = e.response?.data;
    final map = body is Map<String, dynamic> ? body : <String, dynamic>{};
    final status = e.response?.statusCode;
    var code = parseString(map['code']);
    if (code == null && status == 400 && map['errors'] is Map) {
      code = MainSourceErrorCode.validation;
    }
    final message = parseString(map['message']) ?? e.dioMessage;
    return MainSourceApiException(
      statusCode: status,
      code: code,
      message: message,
      data: map,
    );
  }

  Map<String, dynamic> _data(Response response) =>
      asMap(asMap(response.data)['data']);

  Paginated<T> _page<T>(dynamic json, T Function(Map<String, dynamic>) parse) {
    final map = asMap(json);
    return Paginated<T>(
      items: asList(map['data'], parse),
      currentPage: parseInt(map['current_page']) ?? 1,
      lastPage: parseInt(map['last_page']) ?? 1,
      total: parseInt(map['total']) ?? 0,
    );
  }

  // ---------------------------------------------------------------- launch

  @override
  Future<BusinessConfigModel> getBusinessConfig() => _guard(() async {
        final response = await dio.get('$_base/app/business-config');
        return BusinessConfigModel.fromJson(_data(response));
      });

  // ------------------------------------------------------------- catalogue

  @override
  Future<MainSourceHomeModel> getHome({int productsLimit = 10}) =>
      _guard(() async {
        final response = await dio.get('$_base/main-source/home',
            queryParameters: {'products_limit': productsLimit});
        return MainSourceHomeModel.fromJson(_data(response));
      });

  @override
  Future<List<MainSourceModel>> getMainSources() => _guard(() async {
        final response = await dio.get('$_base/main-sources');
        return asList(asMap(response.data)['data'], MainSourceModel.fromJson);
      });

  @override
  Future<List<MainSourceCategoryModel>> getCategories({int? mainSourceId}) =>
      _guard(() async {
        final response = await dio.get('$_base/main-source/categories',
            queryParameters: {
              if (mainSourceId != null) 'main_source_id': mainSourceId,
            });
        return asList(
            asMap(response.data)['data'], MainSourceCategoryModel.fromJson);
      });

  @override
  Future<Paginated<MainSourceProductModel>> getProducts(
          MainSourceProductParams params) =>
      _guard(() async {
        final response = await dio.get('$_base/main-source/products',
            queryParameters: params.toQuery());
        return _page(
            asMap(response.data)['data'], MainSourceProductModel.fromJson);
      });

  @override
  Future<MainSourceProductModel> getProduct(int id) => _guard(() async {
        final response = await dio.get('$_base/main-source/products/$id');
        return MainSourceProductModel.fromJson(_data(response));
      });

  // ------------------------------------------------------------------ cart

  MainSourceCartModel _cart(Response response) =>
      MainSourceCartModel.fromJson(_data(response));

  @override
  Future<MainSourceCartModel> getCart() => _guard(() async {
        return _cart(await dio.get('$_base/main-source/cart'));
      });

  @override
  Future<MainSourceCartCount> getCartCount() => _guard(() async {
        final response = await dio.get('$_base/main-source/cart/count');
        return MainSourceCartCount.fromJson(_data(response));
      });

  @override
  Future<MainSourceCartModel> addToCart(
          {required int variantId,
          int quantity = 1,
          bool replaceCart = false}) =>
      _guard(() async {
        return _cart(await dio.post('$_base/main-source/cart/add', data: {
          'variant_id': variantId,
          'quantity': quantity,
          if (replaceCart) 'replace_cart': true,
        }));
      });

  @override
  Future<MainSourceCartModel> updateCartItem(int cartItemId, int quantity) =>
      _guard(() async {
        return _cart(await dio.put('$_base/main-source/cart/$cartItemId',
            data: {'quantity': quantity}));
      });

  @override
  Future<MainSourceCartModel> removeCartItem(int cartItemId) =>
      _guard(() async {
        return _cart(await dio.delete('$_base/main-source/cart/$cartItemId'));
      });

  @override
  Future<MainSourceCartModel> clearCart() => _guard(() async {
        return _cart(await dio.delete('$_base/main-source/cart/clear'));
      });

  // -------------------------------------------------------------- checkout

  @override
  Future<MainSourceQuoteModel> quote(MainSourceCheckoutParams params) =>
      _guard(() async {
        final response = await dio.post('$_base/main-source/orders/quote',
            data: params.toQuoteJson());
        return MainSourceQuoteModel.fromJson(_data(response));
      });

  @override
  Future<MainSourcePlaceOrderResult> placeOrder(
          MainSourceCheckoutParams params) =>
      _guard(() async {
        final response = await dio.post('$_base/main-source/orders',
            data: params.toOrderJson());
        return MainSourcePlaceOrderResult.fromJson(_data(response));
      });

  @override
  Future<MainSourcePaymentVerifyResult> verifyPayment(String checkoutId) =>
      _guard(() async {
        final response = await dio
            .get('$_base/main-source/payments/verify/$checkoutId');
        return MainSourcePaymentVerifyResult.fromJson(_data(response));
      });

  @override
  Future<MainSourcePayStartResult> payOrder(int orderId) => _guard(() async {
        final response =
            await dio.post('$_base/main-source/orders/$orderId/pay');
        return MainSourcePayStartResult.fromJson(_data(response));
      });

  // ---------------------------------------------------------------- orders

  @override
  Future<Paginated<MainSourceOrderModel>> getOrders(
          {int page = 1, int limit = 15, List<String>? statuses}) =>
      _guard(() async {
        final response =
            await dio.get('$_base/main-source/orders', queryParameters: {
          'page': page,
          'limit': limit,
          if (statuses != null && statuses.length == 1) 'status': statuses.first,
          if (statuses != null && statuses.length > 1) 'status[]': statuses,
        });
        return _page(
            asMap(response.data)['data'], MainSourceOrderModel.fromJson);
      });

  @override
  Future<MainSourceOrderModel> getOrder(int id) => _guard(() async {
        final response = await dio.get('$_base/main-source/orders/$id');
        return MainSourceOrderModel.fromJson(_data(response));
      });

  @override
  Future<MainSourceOrderModel> cancelOrder(int id, {String? reason}) =>
      _guard(() async {
        final response =
            await dio.post('$_base/main-source/orders/$id/cancel', data: {
          if (reason != null && reason.trim().isNotEmpty) 'reason': reason,
        });
        return MainSourceOrderModel.fromJson(_data(response));
      });

  @override
  Future<MainSourceReorderResult> reorder(int id) => _guard(() async {
        final response =
            await dio.post('$_base/main-source/orders/$id/reorder');
        return MainSourceReorderResult.fromJson(_data(response),
            message: parseString(asMap(response.data)['message']));
      });

  @override
  Future<void> downloadInvoice(int id, String savePath) => _guard(() async {
        await dio.download('$_base/main-source/orders/$id/invoice', savePath);
      });

  @override
  Future<MainSourceOrderModel> uploadBankTransfer(
          int orderId, MainSourceBankTransferParams params,
          {void Function(int sent, int total)? onProgress}) =>
      _guard(() async {
        final form = FormData.fromMap({
          'bank_account_id': params.bankAccountId,
          'amount': params.amount,
          if (params.referenceNumber != null &&
              params.referenceNumber!.trim().isNotEmpty)
            'reference_number': params.referenceNumber!.trim(),
          if (params.transferDate != null) 'transfer_date': params.transferDate,
          'receipt_image': await MultipartFile.fromFile(params.filePath,
              filename: params.fileName),
        });
        final response = await dio.post(
          '$_base/main-source/orders/$orderId/bank-transfer',
          data: form,
          onSendProgress: onProgress,
        );
        return MainSourceOrderModel.fromJson(_data(response));
      });
}
