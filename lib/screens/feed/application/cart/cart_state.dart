// application/cart/cart_state.dart
import 'package:equatable/equatable.dart';

import '../../domain/entities/cart/feed_cart_model.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartAdded extends CartState {}

// class CartLoaded extends CartState {
//   final List<FeedCartItemModel> cartItems;
//   final num? totalAmount;
//   final int cartCount;

//   CartLoaded(this.cartItems,
//    {this.totalAmount, this.cartCount = 0,});

//   @override
//   List<Object?> get props => [cartItems, totalAmount, cartCount];
// }

class CartLoaded extends CartState {
  final List<FeedCartItemModel> cartItems;
  final num? totalAmount;
  final int cartCount; // non-nullable, default 0
  final Set<int> updatingItemIds;

  CartLoaded(
    this.cartItems, {
    this.totalAmount,
    this.cartCount = 0,
    this.updatingItemIds = const {},
  });

  // copyWith allows updating parts of the state without overwriting the rest
  CartLoaded copyWith({
    List<FeedCartItemModel>? cartItems,
    num? totalAmount,
    int? cartCount,
    Set<int>? updatingItemIds,
  }) {
    return CartLoaded(
      cartItems ?? this.cartItems,
      totalAmount: totalAmount ?? this.totalAmount,
      cartCount: cartCount ?? this.cartCount,
      updatingItemIds: updatingItemIds ?? this.updatingItemIds,
    );
  }

  @override
  List<Object?> get props =>
      [cartItems, totalAmount, cartCount, updatingItemIds];
}

class CartCountLoaded extends CartState {
  final int count;
  CartCountLoaded(this.count);
  @override
  List<Object?> get props => [count];
}

class CartError extends CartState {
  final Object message;
  CartError(this.message);
  @override
  List<Object?> get props => [message];
}
