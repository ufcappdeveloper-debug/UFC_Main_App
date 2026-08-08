import 'package:ufc_mobile/screens/feed/domain/entities/order/order_model.dart';

abstract class MyOrdersState {}

class MyOrdersInitial extends MyOrdersState {}

class MyOrdersLoading extends MyOrdersState {}

class MyOrdersLoaded extends MyOrdersState {
  final List<OrderModel> orders;
  final int currentPage;
  final int lastPage;
  final bool hasReachedEnd;

  MyOrdersLoaded({
    required this.orders,
    required this.currentPage,
    required this.lastPage,
    this.hasReachedEnd = false,
  });

  MyOrdersLoaded copyWith({
    List<OrderModel>? orders,
    int? currentPage,
    int? lastPage,
    bool? hasReachedEnd,
  }) {
    return MyOrdersLoaded(
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class MyOrdersError extends MyOrdersState {
  final Object message;

  MyOrdersError(this.message);
}
