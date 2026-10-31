// application/cart/cart_cubit.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/cart/feed_cart_model.dart';

import '../../domain/entities/cart/feed_add_cart_params_model.dart';
import '../../domain/usecases/cart_usecase.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddToCartUseCase addToCartUseCase;
  final GetCartUseCase getCartUseCase;
  final GetCartCountUseCase getCartCountUseCase;
  final IncrementQuantityUseCase incrementQuantityUseCase;
  final DecrementQuantityUseCase decrementQuantityUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final AddPastOrdersUseCase addPastOrdersUseCase;

  CartCubit(
    this.addToCartUseCase,
    this.getCartUseCase,
    this.getCartCountUseCase,
    this.incrementQuantityUseCase,
    this.decrementQuantityUseCase,
    this.removeFromCartUseCase,
    this.clearCartUseCase,
    this.addPastOrdersUseCase,
  ) : super(CartInitial());

  int getExistingQuantityForVariant(int? variationId) {
    final currentState = state;
    if (currentState is CartLoaded) {
      final existingItem = currentState.cartItems.firstWhere(
        (item) => item.variationId == variationId,
        orElse: () => FeedCartItemModel(quantity: 0),
      );
      return existingItem.quantity ?? 0;
    }
    return 0;
  }

  Future<void> addToCart(AddToCartParams params, {int? availableStock}) async {
    emit(CartLoading());

    try {
      // latest quantity in the cart (a failure here stops the add)
      final latest = await getCartUseCase();
      final existingQty = (latest.cart ?? [])
          .where((item) => item.variationId == params.variantId)
          .fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));
      final remainingStock = (availableStock ?? 0) - existingQty;

      if (remainingStock <= 0) {
        emit(CartError("No more stock available"));
        return;
      }

      if ((params.quantity ?? 0) > remainingStock) {
        emit(CartError(
          isEnglish
              ? "Only $remainingStock item${remainingStock == 1 ? '' : 's'} left in stock"
              : (remainingStock == 0
                  ? "لا يوجد مخزون متاح"
                  : (remainingStock == 1
                      ? "يتبقى عنصر واحد فقط في المخزون"
                      : "يتبقى $remainingStock عناصر في المخزون")),
        ));
        return;
      }

      // add item
      await addToCartUseCase(params);

      // fetch updated cart
      final response = await getCartUseCase();
      final count = await _countOrLast();

      // emit CartLoaded directly with updated cart and count
      emit(CartAdded());
      emit(CartLoaded(
        response.cart ?? [],
        totalAmount: response.totalAmount ?? 0,
        cartCount: count,
      ));
    } on DioException catch (e) {
      emit(CartError(e.dioMessage));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // Future<void> incrementQuantity(int id) async {
  //   try {
  //     await incrementQuantityUseCase(id);
  //     await fetchCart(); // refresh UI
  //     await fetchCartCount();
  //   } on DioException catch (e) {
  //     emit(CartError(e.dioMessage));
  //   } catch (e) {
  //     emit(CartError(e));
  //   }
  // }

  // Future<void> decrementQuantity(int id) async {
  //   try {
  //     await decrementQuantityUseCase(id);
  //     await fetchCart();
  //     await fetchCartCount();
  //   } on DioException catch (e) {
  //     emit(CartError(e.dioMessage));
  //   } catch (e) {
  //     emit(CartError(e));
  //   }
  // }

  Future<void> incrementQuantity(int id) async {
    if (state is! CartLoaded) return;
    final current = state as CartLoaded;

    emit(current.copyWith(
      updatingItemIds: {...current.updatingItemIds, id},
    ));

    try {
      await incrementQuantityUseCase(id);

      // fetch updated cart
      final response = await getCartUseCase();
      final count = await _countOrLast();

      emit(current.copyWith(
        cartItems: response.cart ?? [],
        totalAmount: response.totalAmount ?? 0,
        cartCount: count,
        updatingItemIds: {},
      ));
    } catch (e) {
      // Remove loading state on error
      emit(current.copyWith(updatingItemIds: {}));
      if (_isNotFound(e)) return fetchCart();
      emit(CartError(_message(e)));
    }
  }

  String _message(Object e) => e is DioException ? e.dioMessage : e.toString();

  /// The API returns 404 for a cart item that isn't the user's (any more).
  bool _isNotFound(Object e) =>
      e is DioException && e.response?.statusCode == 404;

  Future<void> decrementQuantity(int id) async {
    try {
      // Mark item as updating
      if (state is CartLoaded) {
        final current = state as CartLoaded;
        emit(current.copyWith(
          updatingItemIds: {...current.updatingItemIds, id},
        ));
      }

      await decrementQuantityUseCase(id);

      // fetch updated cart
      final response = await getCartUseCase();
      final count = await _countOrLast();

      if (state is CartLoaded) {
        emit((state as CartLoaded).copyWith(
          cartItems: response.cart ?? [],
          totalAmount: response.totalAmount ?? 0,
          cartCount: count,
          updatingItemIds: {},
        ));
      }
    } catch (e) {
      // Remove loading state on error
      if (state is CartLoaded) {
        emit((state as CartLoaded).copyWith(
          updatingItemIds: {},
        ));
      }
      if (_isNotFound(e)) return fetchCart();
      emit(CartError(_message(e)));
    }
  }

  Future<void> removeFromCart(int id) async {
    try {
      await removeFromCartUseCase(id);
      await fetchCart();
      await fetchCartCount();
    } on DioException catch (e) {
      if (_isNotFound(e)) return fetchCart();
      emit(CartError(e.dioMessage));
    } catch (e) {
      emit(CartError(e));
    }
  }

  Future<void>? _fetching;

  /// Joins a fetch already in progress instead of sending a second one.
  Future<void> fetchCart() =>
      _fetching ??= _fetchCart().whenComplete(() => _fetching = null);

  Future<void> _fetchCart() async {
    emit(CartLoading());
    try {
      final response = await getCartUseCase();

      // First, emit the cart items
      final loadedState = CartLoaded(
        response.cart ?? [],
        totalAmount: response.totalAmount ?? 0,
        cartCount: lastCount,
      );
      emit(loadedState);

      // Then fetch and update the cart count
      await fetchCartCount();
    } on DioException catch (e) {
      emit(CartError(e.dioMessage));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Last known shop cart count, available in any state (bottom-bar badge).
  int lastCount = 0;

  /// The count, or the last known one if the request fails. The count only
  /// feeds the badge, so its failure must never replace a loaded cart.
  Future<int> _countOrLast() async {
    try {
      lastCount = await getCartCountUseCase();
    } catch (e) {
      debugPrint('Cart count failed: $e');
    }
    return lastCount;
  }

  Future<void> fetchCartCount() async {
    final count = await _countOrLast();

    final currentState = state;
    if (currentState is CartLoaded) {
      // emit updated state with new cartCount
      emit(currentState.copyWith(cartCount: count));
    } else if (currentState is CartInitial ||
        currentState is CartCountLoaded) {
      emit(CartCountLoaded(count));
    }
  }

  Future<void> clearCart() async {
    try {
      await clearCartUseCase();
      await fetchCart();
      await fetchCartCount();
    } on DioException catch (e) {
      emit(CartError(e.dioMessage));
    } catch (e) {
      emit(CartError(e));
    }
  }

  Future<void> addPastOrders(int orderId) async {
    emit(CartLoading());
    try {
      await clearCartUseCase();
      await addPastOrdersUseCase(orderId);
      final responseCart = await getCartUseCase();

      emit(CartLoaded(
        responseCart.cart ?? [],
        totalAmount: responseCart.totalAmount ?? 0,
        cartCount: lastCount,
      ));
      await fetchCartCount();
    } on DioException catch (e) {
      emit(CartError(e.dioMessage));
    } catch (e) {
      emit(CartError(e));
    }
  }
}
