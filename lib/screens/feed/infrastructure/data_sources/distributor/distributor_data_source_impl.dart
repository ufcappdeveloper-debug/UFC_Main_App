import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

import '../../../domain/entities/distributor/checkout_options_model.dart';
import '../../../domain/entities/distributor/checkout_summary_model.dart';
import '../../../domain/entities/distributor/distributor_cart_model.dart';
import '../../../domain/entities/distributor/distributor_category_model.dart';
import '../../../domain/entities/distributor/distributor_model.dart';
import '../../../domain/entities/distributor/distributor_place_order_result.dart';
import '../../../domain/entities/distributor/distributor_product_model.dart';
import '../../../domain/entities/distributor/distributor_query_params.dart';
import 'distributor_data_source.dart';

/// Distributor endpoints (`/api/ufc/v1/distributor/...`). Browsing works
/// without a token; the shared [AppInterceptor] adds it when available.
class DistributorRemoteDataSourceImpl implements DistributorRemoteDataSource {
  final Dio dio;

  DistributorRemoteDataSourceImpl(this.dio);

  static const _base = '/api/ufc/v1/distributor';

  /// Runs [request] and turns API errors into [DistributorApiException].
  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      final data = e.response?.data;
      final map = data is Map ? data : const {};
      final nested = map['data'];
      String message = e.dioMessage;
      if (nested is Map && nested['message'] != null) {
        message = nested['message'].toString();
      } else if (map['message'] != null) {
        message = map['message'].toString();
      }
      throw DistributorApiException(
        statusCode: e.response?.statusCode,
        message: message,
        code: map['code']?.toString(),
        variantId: parseInt(map['variant_id']),
        availableStock: parseInt(map['available_stock']),
        allowedPaymentMethods: map['allowed_payment_methods'] is List
            ? (map['allowed_payment_methods'] as List)
                .map((e) => e.toString())
                .toList()
            : const [],
      );
    }
  }

  Paginated<T> _page<T>(dynamic json, T Function(Map<String, dynamic>) parse) {
    if (json is! Map) return const Paginated();
    final list = json['data'];
    return Paginated<T>(
      items: list is List
          ? list.whereType<Map<String, dynamic>>().map(parse).toList()
          : <T>[],
      currentPage: parseInt(json['current_page']) ?? 1,
      lastPage: parseInt(json['last_page']) ?? 1,
      total: parseInt(json['total']) ?? 0,
    );
  }

  @override
  Future<Paginated<DistributorModel>> getDistributors(
          DistributorListParams params) =>
      _guard(() async {
        final response = await dio.get('$_base/get_distributors',
            queryParameters: params.toQuery());
        return _page(response.data['data'], DistributorModel.fromJson);
      });

  @override
  Future<DistributorModel> getDistributorDetail(int id) => _guard(() async {
        final response = await dio.get('$_base/detail/$id');
        return DistributorModel.fromJson(response.data['data']);
      });

  @override
  Future<List<DistributorCategoryModel>> getCategories(int distributorId) =>
      _guard(() async {
        final response = await dio.get('$_base/get_categories',
            queryParameters: {'distributor_id': distributorId});
        final list = response.data['data'];
        return list is List
            ? list
                .whereType<Map<String, dynamic>>()
                .map(DistributorCategoryModel.fromJson)
                .toList()
            : <DistributorCategoryModel>[];
      });

  @override
  Future<Paginated<DistributorProductModel>> getProducts(
          DistributorProductParams params) =>
      _guard(() async {
        final response = await dio.get('$_base/get_products',
            queryParameters: params.toQuery());
        return _page(
            response.data['products'], DistributorProductModel.fromJson);
      });

  @override
  Future<DistributorProductModel> getProduct(int id) => _guard(() async {
        final response = await dio.get('$_base/product/$id',
            queryParameters: {'fetch_favorite': 1});
        return DistributorProductModel.fromJson(response.data['product']);
      });

  @override
  Future<void> addToCart(AddDistributorCartParams params) => _guard(() async {
        await dio.post('$_base/cart/add', data: params.toJson());
      });

  @override
  Future<DistributorCartModel> getCart() => _guard(() async {
        final response = await dio.get('$_base/cart');
        return DistributorCartModel.fromJson(response.data);
      });

  @override
  Future<int> getCartCount() => _guard(() async {
        final response = await dio.get('$_base/cart/count');
        return parseInt(response.data['cart']) ?? 0;
      });

  @override
  Future<void> incrementQuantity(int cartItemId) => _guard(() async {
        await dio.get('$_base/cart/quantity/increment/$cartItemId');
      });

  @override
  Future<void> decrementQuantity(int cartItemId) => _guard(() async {
        await dio.get('$_base/cart/quantity/decrement/$cartItemId');
      });

  @override
  Future<void> updateQuantity(int cartItemId, int quantity) =>
      _guard(() async {
        await dio.put('$_base/cart/quantity/update/$cartItemId',
            data: {'quantity': quantity});
      });

  @override
  Future<void> removeFromCart(int cartItemId) => _guard(() async {
        await dio.delete('$_base/cart/$cartItemId');
      });

  @override
  Future<void> clearCart() => _guard(() async {
        await dio.delete('$_base/cart/clear');
      });

  @override
  Future<CheckoutOptionsModel> getCheckoutOptions(int distributorId) =>
      _guard(() async {
        final response =
            await dio.get('$_base/checkout_options/$distributorId');
        return CheckoutOptionsModel.fromJson(response.data['data']);
      });

  @override
  Future<DistributorCheckoutSummary> getCheckoutSummary({
    required String orderType,
    String? couponCode,
  }) =>
      _guard(() async {
        final response =
            await dio.get('$_base/checkout_summary', queryParameters: {
          'order_type': orderType,
          if (couponCode != null && couponCode.isNotEmpty)
            'coupon_code': couponCode,
        });
        return DistributorCheckoutSummary.fromJson(response.data['data']);
      });

  @override
  Future<DistributorPlaceOrderResult> placeOrder(
          DistributorPlaceOrderParams params) =>
      _guard(() async {
        final response =
            await dio.post('$_base/place_order', data: params.toJson());
        return DistributorPlaceOrderResult.fromJson(response.data);
      });

  @override
  Future<DistributorPlaceOrderResult> buyProduct(
          DistributorBuyProductParams params) =>
      _guard(() async {
        final response =
            await dio.post('$_base/buy_product', data: params.toJson());
        return DistributorPlaceOrderResult.fromJson(response.data);
      });

  @override
  Future<PlaceOrderAgainResult> placeOrderAgain(int orderId) =>
      _guard(() async {
        final response = await dio
            .post('$_base/place_order_again', data: {'order_id': orderId});
        final skipped = response.data['skipped_variant_ids'];
        return PlaceOrderAgainResult(
          skippedVariantIds: skipped is List
              ? skipped.map(parseInt).whereType<int>().toList()
              : const [],
        );
      });

  @override
  Future<bool> toggleFavorite(int productId) => _guard(() async {
        final response = await dio.get('$_base/fav_product/$productId');
        return parseBool(response.data['is_favorite']) ?? false;
      });

  @override
  Future<Paginated<DistributorProductModel>> getFavorites(int page) =>
      _guard(() async {
        final response = await dio.get('$_base/fav_product_list',
            queryParameters: {'page': page, 'limit': 20});
        // Each row wraps the product: { id, distributor_product_id, product }
        return _page(response.data['data'], (row) {
          final product = row['product'] is Map<String, dynamic>
              ? row['product'] as Map<String, dynamic>
              : row;
          return DistributorProductModel.fromJson(product)
            ..id ??= parseInt(row['distributor_product_id'])
            ..favorite = true;
        });
      });
}
