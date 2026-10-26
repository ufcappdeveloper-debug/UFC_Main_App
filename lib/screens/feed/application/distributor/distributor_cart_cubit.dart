import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/distributor/distributor_cart_model.dart';
import '../../domain/entities/distributor/distributor_place_order_result.dart';
import '../../domain/repositories/distributor_repo.dart';

enum DistributorCartEvent { none, added, conflict, error, reordered }

class DistributorCartState extends Equatable {
  final DistributorCartModel cart;
  final int count;
  final bool loading;
  final bool loaded;
  final Set<int> updatingItemIds;

  /// One-shot UI event (snackbar / dialog). [eventId] changes on each one.
  final DistributorCartEvent event;
  final int eventId;
  final String? message;

  /// The add request that hit the 409 "another distributor" conflict.
  final AddDistributorCartParams? pendingAdd;

  const DistributorCartState({
    required this.cart,
    this.count = 0,
    this.loading = false,
    this.loaded = false,
    this.updatingItemIds = const {},
    this.event = DistributorCartEvent.none,
    this.eventId = 0,
    this.message,
    this.pendingAdd,
  });

  DistributorCartState copyWith({
    DistributorCartModel? cart,
    int? count,
    bool? loading,
    bool? loaded,
    Set<int>? updatingItemIds,
  }) =>
      DistributorCartState(
        cart: cart ?? this.cart,
        count: count ?? this.count,
        loading: loading ?? this.loading,
        loaded: loaded ?? this.loaded,
        updatingItemIds: updatingItemIds ?? this.updatingItemIds,
        event: event,
        eventId: eventId,
        message: message,
        pendingAdd: pendingAdd,
      );

  DistributorCartState withEvent(DistributorCartEvent event,
          {String? message, AddDistributorCartParams? pendingAdd}) =>
      DistributorCartState(
        cart: cart,
        count: count,
        loading: false,
        loaded: loaded,
        updatingItemIds: const {},
        event: event,
        eventId: eventId + 1,
        message: message,
        pendingAdd: pendingAdd,
      );

  @override
  List<Object?> get props => [
        cart.items.map((e) => '${e.id}:${e.quantity}').join(','),
        cart.totalAmount,
        count,
        loading,
        loaded,
        updatingItemIds,
        eventId,
      ];
}

/// The distributor cart. Separate from the shop cart (`CartCubit`):
/// one distributor at a time, 409 when adding from another one.
class DistributorCartCubit extends Cubit<DistributorCartState> {
  final DistributorRepository repository;

  DistributorCartCubit(this.repository)
      : super(DistributorCartState(cart: DistributorCartModel()));

  Future<void> fetchCart({bool silent = false}) async {
    if (!silent) emit(state.copyWith(loading: true));
    try {
      final cart = await repository.getCart();
      emit(state.copyWith(
          cart: cart, count: cart.count, loading: false, loaded: true));
    } catch (e) {
      emit(state.copyWith(loading: false, loaded: true)
          .withEvent(DistributorCartEvent.error, message: e.toString()));
    }
  }

  /// Emits in any state (unlike the old shop cart count).
  Future<void> fetchCartCount() async {
    try {
      final count = await repository.getCartCount();
      emit(state.copyWith(count: count));
    } catch (_) {
      // Not logged in or offline: keep the current badge.
    }
  }

  Future<void> addToCart(AddDistributorCartParams params) async {
    emit(state.copyWith(loading: true));
    try {
      await repository.addToCart(params);
      final cart = await repository.getCart();
      emit(state
          .copyWith(cart: cart, count: cart.count, loaded: true)
          .withEvent(DistributorCartEvent.added));
    } on DistributorApiException catch (e) {
      if (e.isCartConflict && !params.replaceCart) {
        emit(state.withEvent(DistributorCartEvent.conflict,
            message: e.message, pendingAdd: params));
      } else {
        emit(state.withEvent(DistributorCartEvent.error, message: e.message));
      }
    } catch (e) {
      emit(state.withEvent(DistributorCartEvent.error, message: e.toString()));
    }
  }

  /// User confirmed "Start a new cart?" after a 409.
  Future<void> confirmReplaceCart() async {
    final pending = state.pendingAdd;
    if (pending == null) return;
    await addToCart(pending.copyWith(replaceCart: true));
  }

  Future<void> _mutate(int itemId, Future<void> Function() action) async {
    emit(state.copyWith(updatingItemIds: {...state.updatingItemIds, itemId}));
    try {
      await action();
      final cart = await repository.getCart();
      emit(state.copyWith(
          cart: cart, count: cart.count, updatingItemIds: const {}));
    } catch (e) {
      emit(state.withEvent(DistributorCartEvent.error, message: e.toString()));
      await fetchCart(silent: true);
    }
  }

  Future<void> increment(int itemId) =>
      _mutate(itemId, () => repository.incrementQuantity(itemId));

  Future<void> decrement(int itemId) =>
      _mutate(itemId, () => repository.decrementQuantity(itemId));

  Future<void> setQuantity(int itemId, int quantity) =>
      _mutate(itemId, () => repository.updateQuantity(itemId, quantity));

  Future<void> remove(int itemId) =>
      _mutate(itemId, () => repository.removeFromCart(itemId));

  Future<void> clear() async {
    try {
      await repository.clearCart();
    } finally {
      await fetchCart(silent: true);
    }
  }

  /// "Order again" for a distributor order: replaces the cart with that
  /// order's lines. Returns the skipped variant ids.
  Future<List<int>> placeOrderAgain(int orderId) async {
    emit(state.copyWith(loading: true));
    try {
      final result = await repository.placeOrderAgain(orderId);
      final cart = await repository.getCart();
      emit(state
          .copyWith(cart: cart, count: cart.count, loaded: true)
          .withEvent(DistributorCartEvent.reordered));
      return result.skippedVariantIds;
    } catch (e) {
      emit(state.withEvent(DistributorCartEvent.error, message: e.toString()));
      rethrow;
    }
  }
}
