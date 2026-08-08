import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../../global/config/config.dart';
import '../../domain/entities/cart/feed_add_cart_params_model.dart';
import '../../domain/entities/cart/feed_cart_model.dart';
import 'cart_data_source.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio;

  CartRemoteDataSourceImpl(this.dio);

  @override
  Future<void> addToCart(AddToCartParams params) async {
    await api.post(
      "/api/ufc/v1/cart/add",
      data: params.toJson(),
      options: Options(headers: {
        "Authorization": "Bearer ${AppConfig.token}",
      }),
    );
  }

  @override
  Future<FeedCartResponseModel> getCart() async {
    final response = await api.get(
      "/api/ufc/v1/cart",
      options: Options(headers: {
        "Authorization": "Bearer ${AppConfig.token}",
      }),
    );

    print("✅ API Response: ${response.data}");

    // Use response.data directly instead of response.data['data']
    final data = response.data;

    return FeedCartResponseModel.fromJson(data);
  }

  @override
  Future<void> incrementQuantity(int cartItemId) async {
    await api.get(
      "/api/ufc/v1/cart/quantity/increment/$cartItemId",
      options: Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
    );
  }

  @override
  Future<void> decrementQuantity(int cartItemId) async {
    await api.get(
      "/api/ufc/v1/cart/quantity/decrement/$cartItemId",
      options: Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
    );
  }

  @override
  Future<void> removeFromCart(int cartItemId) async {
    await dio.delete(
      "/api/ufc/v1/cart/$cartItemId",
      options: Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
    );
  }

  @override
  Future<void> clearCart() async {
    await dio.delete(
      "/api/ufc/v1/cart/clear",
      options: Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
    );
  }

  @override
  Future<int> getCartCount() async {
    try {
      final response = await api.get(
        "/api/ufc/v1/cart/count",
        options: Options(headers: {
          "Authorization": "Bearer ${AppConfig.token}",
        }),
      );
      return response.data['cart'] ?? 0;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FeedCartItemModel>> addPastOrders(int orderId) async {
    final response = await api.post(
      "/api/ufc/v1/place_order_again",
      data: {
        'order_id': orderId,
      },
      options: Options(headers: {
        "Authorization": "Bearer ${AppConfig.token}",
      }),
    );
    return (response.data["cartItems"] as List<dynamic>)
        .map((data) => FeedCartItemModel.fromJson(data))
        .toList();
  }
}
