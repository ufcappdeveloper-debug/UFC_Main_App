import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/global/util/extension/string_extensions.dart';

class CartService {
  Future<Set> getCartItems() async {
    Response response = await api.get(
      "api/ufc/v1/cart",
    );
    return {
      response.data['total_amount']?.toString().toTryDouble(),
      (response.data["cart"] as List<dynamic>)
          .map((data) => CartItemModel.fromJson(data))
          .toList()
    };
  }

  Future<bool> addToCart(final data) async {
    Response response = await api.post("api/ufc/v1/cart/add", data: data);
    return response.data["message"] == "Item added to cart successfully";
  }

  Future<CartItemModel> incrementCartItem(int cartItemId) async {
    Response response = await api.get(
      "api/ufc/v1/cart/quantity/increment/$cartItemId",
    );
    return CartItemModel.fromJson(response.data["cart"]);
  }

  Future<CartItemModel> decrementCartItem(int cartItemId) async {
    Response response = await api.get(
      "api/ufc/v1/cart/quantity/decrement/$cartItemId",
    );
    return CartItemModel.fromJson(response.data["cart"]);
  }

  Future<bool> deleteCartItem(int cartItemId) async {
    Response response = await api.delete(
      "api/ufc/v1/cart/$cartItemId",
    );
    return response.data['message'] == 'Cart item deleted successfully';
  }

  Future<List<CartItemModel>> addPastOrders(final int orderId) async {
    Response response = await api.post(
      "api/ufc/v1/place_order_again",
      data: {
        'order_id': orderId,
      },
    );

    return (response.data["cartItems"] as List<dynamic>)
        .map((data) => CartItemModel.fromJson(data))
        .toList();
  }
}
