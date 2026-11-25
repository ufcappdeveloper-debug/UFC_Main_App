import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/main_source/main_source_api_exception.dart';
import '../../domain/entities/main_source/main_source_cart_model.dart';
import '../../domain/entities/main_source/main_source_payment_models.dart';
import '../../domain/repositories/main_source_repo.dart';

enum MainSourceCartEvent { none, added, conflict, error, reordered }

/// An add request waiting for "Clear it and add this product?".
class MainSourcePendingAdd {
  final int variantId;
  final int quantity;

  const MainSourcePendingAdd(this.variantId, this.quantity);
}

class MainSourceCartState extends Equatable {
  final MainSourceCartModel cart;

  /// Cart badge (`/cart/count` → `items`).
  final int count;
  final bool loading;
  final bool loaded;
  final Set<int> updatingItemIds;

  /// One-shot UI event (snackbar / dialog). [eventId] changes on each one.
  final MainSourceCartEvent event;
  final int eventId;
  final Object? error;
  final MainSourcePendingAdd? pendingAdd;

  const MainSourceCartState({
    this.cart = MainSourceCartModel.empty,
    this.count = 0,
    this.loading = false,
    this.loaded = false,
    this.updatingItemIds = const {},
    this.event = MainSourceCartEvent.none,
    this.eventId = 0,
    this.error,
    this.pendingAdd,
  });

  MainSourceCartState copyWith({
    MainSourceCartModel? cart,
    int? count,
    bool? loading,
    bool? loaded,
    Set<int>? updatingItemIds,
  }) =>
      MainSourceCartState(
        cart: cart ?? this.cart,
        count: count ?? this.count,
        loading: loading ?? this.loading,
        loaded: loaded ?? this.loaded,
        updatingItemIds: updatingItemIds ?? this.updatingItemIds,
        event: event,
        eventId: eventId,
        error: error,
        pendingAdd: pendingAdd,
      );

  MainSourceCartState withEvent(MainSourceCartEvent event,
          {Object? error, MainSourcePendingAdd? pendingAdd}) =>
      MainSourceCartState(
        cart: cart,
        count: count,
        loading: false,
        loaded: loaded,
        updatingItemIds: const {},
        event: event,
        eventId: eventId + 1,
        error: error,
        pendingAdd: pendingAdd,
      );

  /// The `MIXED_MAIN_SOURCE_CART` error, when [event] is a conflict.
  MainSourceApiException? get apiError =>
      error is MainSourceApiException ? error as MainSourceApiException : null;

  @override
  List<Object?> get props =>
      [cart.signature, count, loading, loaded, updatingItemIds, eventId];
}

/// The server-side Main Source cart: one Main Source at a time
/// (`409 MIXED_MAIN_SOURCE_CART` otherwise). Plan §3.
class MainSourceCartCubit extends Cubit<MainSourceCartState> {
  final MainSourceRepository repository;

  MainSourceCartCubit(this.repository) : super(const MainSourceCartState());

  void _setCart(MainSourceCartModel cart, {MainSourceCartEvent? event}) {
    final next = state.copyWith(
      cart: cart,
      count: cart.itemsCount,
      loading: false,
      loaded: true,
      updatingItemIds: const {},
    );
    emit(event == null ? next : next.withEvent(event));
  }

  Future<void> fetchCart({bool silent = false}) async {
    if (!silent) emit(state.copyWith(loading: true));
    try {
      _setCart(await repository.getCart());
    } catch (e) {
      emit(state
          .copyWith(loading: false, loaded: true)
          .withEvent(MainSourceCartEvent.error, error: e));
    }
  }

  /// Emits in any state; guests / offline keep the current badge.
  Future<void> fetchCartCount() async {
    try {
      final count = await repository.getCartCount();
      emit(state.copyWith(count: count.items));
    } catch (_) {}
  }

  Future<void> addToCart(int variantId,
      {int quantity = 1, bool replaceCart = false}) async {
    emit(state.copyWith(loading: true));
    try {
      final cart = await repository.addToCart(
          variantId: variantId, quantity: quantity, replaceCart: replaceCart);
      _setCart(cart, event: MainSourceCartEvent.added);
    } on MainSourceApiException catch (e) {
      if (e.code == MainSourceErrorCode.mixedCart && !replaceCart) {
        emit(state.withEvent(MainSourceCartEvent.conflict,
            error: e, pendingAdd: MainSourcePendingAdd(variantId, quantity)));
      } else {
        emit(state.withEvent(MainSourceCartEvent.error, error: e));
      }
    } catch (e) {
      emit(state.withEvent(MainSourceCartEvent.error, error: e));
    }
  }

  /// The user agreed to clear the cart after a 409.
  Future<void> confirmReplaceCart() async {
    final pending = state.pendingAdd;
    if (pending == null) return;
    await addToCart(pending.variantId,
        quantity: pending.quantity, replaceCart: true);
  }

  Future<void> _mutate(
      int itemId, Future<MainSourceCartModel> Function() action) async {
    emit(state.copyWith(updatingItemIds: {...state.updatingItemIds, itemId}));
    try {
      _setCart(await action());
    } catch (e) {
      emit(state.withEvent(MainSourceCartEvent.error, error: e));
      await fetchCart(silent: true);
    }
  }

  Future<void> setQuantity(int itemId, int quantity) => quantity < 1
      ? remove(itemId)
      : _mutate(itemId, () => repository.updateCartItem(itemId, quantity));

  Future<void> remove(int itemId) =>
      _mutate(itemId, () => repository.removeCartItem(itemId));

  Future<void> clear() async {
    emit(state.copyWith(loading: true));
    try {
      _setCart(await repository.clearCart());
    } catch (e) {
      emit(state.withEvent(MainSourceCartEvent.error, error: e));
      await fetchCart(silent: true);
    }
  }

  /// "Order again": fills the cart with the order's items that are still
  /// sold. Returns the result (skipped items) or rethrows.
  Future<MainSourceReorderResult> reorder(int orderId) async {
    emit(state.copyWith(loading: true));
    try {
      final result = await repository.reorder(orderId);
      _setCart(result.cart, event: MainSourceCartEvent.reordered);
      return result;
    } catch (e) {
      emit(state.withEvent(MainSourceCartEvent.error, error: e));
      rethrow;
    }
  }

  /// Logout: forget the cart.
  void reset() => emit(const MainSourceCartState());
}
