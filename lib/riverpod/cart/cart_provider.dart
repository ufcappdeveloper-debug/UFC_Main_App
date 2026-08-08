import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/data/cart_service.dart';
import 'package:ufc_mobile/models/cart_item_model.dart';
import 'package:ufc_mobile/global/util/analytic/adjust_tracker.dart';

class CartState extends ChangeNotifier {
  final Ref ref;

  CartState(this.ref) {
    // Initialization logic for socket
  }

  double cartTotal = 0;
  bool isCartFailed = false;
  bool isCartLoading = false;
  double recalculatedCartTotal = 0;
  List<CartItemModel> cartItems = [];

  ///////////* <------ Clear ------> *///////////

  void clear() {
    // Clear logic
    cartTotal = 0;
    cartItems = [];
    isCartFailed = false;
    isCartLoading = false;
    recalculatedCartTotal = 0;
  }

  void get clearAll {
    // Clear all logic
    notifyListeners();
  }

  ///////////* <------ Is Loading ------> *///////////

  void setIsCartLoading(bool value) {
    isCartLoading = value;
    notifyListeners();
  }

  ///////////* <------ Is Failed ------> *///////////

  void setIsCartFailed(bool value) {
    isCartFailed = value;
    notifyListeners();
  }

  ///////////* <------ Set Data ------> *///////////

  void setCartTotal(double value) {
    cartTotal = value;
    notifyListeners();
  }

  void setCartItems(List<CartItemModel> value) {
    cartItems = value;
    notifyListeners();
  }

  void setRecalculatedCartTotal(double value) {
    final calculatedCartTotal = calculateAdjustedCartTotal(cartItems, value);
    recalculatedCartTotal = calculatedCartTotal;
    notifyListeners();
  }

  ///////////* <------ Simplified Utility Methods ------> *///////////

////// Calculate Adjusted Cart Total
  double calculateAdjustedCartTotal(
      List<CartItemModel> cartItems, double cartTotal) {
    // Calculate the total for claimed items
    double claimedItemsTotal = cartItems
        .where((item) => item.isClaimed) // Filter items where isClaimed is true
        .fold(
      0.0,
      (sum, item) {
        // Ensure price and quantity are non-null before calculation
        double price = item.variant?.price ?? 0.0;
        int quantity = item.quantity ?? 0;
        return sum + (price * quantity);
      },
    );

    // Subtract claimed items total from cart total
    return cartTotal - claimedItemsTotal;
  }

  ///////////* <------ Auth Functionality ------> *///////////

  ////// Get Cart Items
  Future<void> getCartItems() async {
    try {
      setIsCartFailed(false);
      setIsCartLoading(true);
      recalculatedCartTotal = 0;

      // Call the CartService to get the cart items
      final Set result = await CartService().getCartItems();
      final items = result.elementAt(1);
      final cartTotal = result.elementAt(0);

      double updatedCartTotal = cartTotal is double ? cartTotal : 0.0;

      if (items is List<CartItemModel>) {
        List<CartItemModel> filteredItems = [];

        for (var item in items) {
          final stock = item.variant?.stock ?? 0;
          final price = item.variant?.price ?? 0;
          final quantity = item.quantity ?? 1;

          if (stock > 0) {
            filteredItems.add(item);
          } else {
            updatedCartTotal -= price * quantity;
          }
        }
        cartItems = filteredItems;
      }

      setCartTotal(updatedCartTotal);
      setRecalculatedCartTotal(updatedCartTotal);
    } catch (e) {
      setIsCartFailed(true);
      rethrow;
    } finally {
      setIsCartLoading(false);
    }
  }

  ////// Get Cart Total
  // Future<void> getCartTotal() async {
  //   try {
  //     // Call the CartService to get the cart items
  //     final Set result = await CartService().getCartItems();
  //     // final items = result.elementAt(1);
  //     final cartTotal = result.elementAt(0);

  //     // if (items is List<CartItemModel>) {
  //     //   cartItems = items;
  //     // }

  //     if (cartTotal is double && cartTotal > 0) {
  //       setCartTotal(cartTotal);
  //       setRecalculatedCartTotal(cartTotal);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  ////// Get Cart Total
  Future<void> getCartTotal() async {
    try {
      final Set result = await CartService().getCartItems();
      final cartTotal = result.elementAt(0);
      final items = result.elementAt(1);

      double updatedCartTotal = cartTotal is double ? cartTotal : 0.0;

      if (items is List<CartItemModel>) {
        for (var item in items) {
          final stock = item.variant?.stock ?? 0;
          final price = item.variant?.price ?? 0;
          final quantity = item.quantity ?? 1;

          if (stock <= 0) {
            updatedCartTotal -= price * quantity;
          }
        }
      }

      setCartTotal(updatedCartTotal);
      setRecalculatedCartTotal(updatedCartTotal);
    } catch (e) {
      rethrow;
    }
  }

  ////// Add To Cart
  Future<bool> addToCart(final Map<String, dynamic> data) async {
    try {
      final result = await CartService().addToCart(data);
      if (result) {
        final productId = data['product_id']?.toString();
        if (productId != null && productId.isNotEmpty) {
          AdjustTracker.trackAddToCart(productId);
        }
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  ////// Add Past Order
  Future<void> addPastOrder(int orderId) async {
    try {
      setIsCartFailed(false);
      setIsCartLoading(true);
      cartItems = await CartService().addPastOrders(orderId);
    } catch (e) {
      setIsCartFailed(true);
      rethrow;
    } finally {
      setIsCartLoading(false);
    }
  }

  ////// Increment Item
  Future<void> incrementItem(int cartItemId) async {
    try {
      int index = cartItems.indexWhere((element) => element.id == cartItemId);

      if (index != -1) {
        CartItemModel item = cartItems[index];

        int currentQuantity = item.quantity ?? 0;
        int availableStock = item.variant?.stock ?? 0;

        if (currentQuantity < availableStock) {
          final cartItem = await CartService().incrementCartItem(cartItemId);
          cartItems[index].quantity = cartItem.quantity;
          await getCartTotal();
        } else {
          debugPrint("Cannot increment. Stock limit reached.");
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  ////// Decrement Item
  Future<void> decrementItem(int cartItemId) async {
    try {
      final cartItem = await CartService().decrementCartItem(cartItemId);
      int index = cartItems.indexWhere((element) => element.id == cartItemId);

      if (index != -1) {
        cartItems[index].quantity = cartItem.quantity;
        await getCartTotal();
      }
    } catch (e) {
      rethrow;
    }
  }

  ////// Delete Item
  Future<void> deleteItem(int cartItemId) async {
    try {
      bool isDeleted = await CartService().deleteCartItem(cartItemId);
      if (isDeleted) {
        cartItems.removeWhere((element) => element.id == cartItemId);
        await getCartTotal();
      }
    } catch (e) {
      rethrow;
    }
  }

  ////// Remove Reward Product Item
  Future<void> removeRewardProductItem(int cartItemId) async {
    try {
      cartItems.removeWhere((element) => element.id == cartItemId);
      await getCartTotal();
    } catch (e) {
      rethrow;
    }
  }
}
