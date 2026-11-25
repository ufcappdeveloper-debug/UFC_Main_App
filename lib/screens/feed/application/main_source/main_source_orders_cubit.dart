import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/main_source/main_source_order_model.dart';
import '../../domain/repositories/main_source_repo.dart';

class MainSourceOrdersState extends Equatable {
  final List<MainSourceOrderModel> orders;
  final bool loading;
  final bool loadingMore;
  final bool loaded;
  final int page;
  final bool hasMore;
  final int total;
  final Object? error;

  const MainSourceOrdersState({
    this.orders = const [],
    this.loading = false,
    this.loadingMore = false,
    this.loaded = false,
    this.page = 1,
    this.hasMore = false,
    this.total = 0,
    this.error,
  });

  @override
  List<Object?> get props => [
        orders
            .map((e) => '${e.id}:${e.orderStatus}:${e.paymentStatus}')
            .join(','),
        loading,
        loadingMore,
        loaded,
        page,
        hasMore,
        total,
        error?.toString(),
      ];
}

/// "My Orders → Main Source" (`GET /main-source/orders`, plan §5).
class MainSourceOrdersCubit extends Cubit<MainSourceOrdersState> {
  final MainSourceRepository repository;

  MainSourceOrdersCubit(this.repository)
      : super(const MainSourceOrdersState());

  Future<void> load() async {
    emit(MainSourceOrdersState(
        orders: state.orders, loading: true, loaded: state.loaded));
    try {
      final page = await repository.getOrders(page: 1);
      emit(MainSourceOrdersState(
        orders: page.items,
        loaded: true,
        page: 1,
        hasMore: page.hasMore,
        total: page.total,
      ));
    } catch (e) {
      emit(MainSourceOrdersState(
          orders: state.orders, loaded: true, error: e));
    }
  }

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;
    emit(MainSourceOrdersState(
      orders: state.orders,
      loaded: true,
      loadingMore: true,
      page: state.page,
      hasMore: state.hasMore,
      total: state.total,
    ));
    try {
      final next = await repository.getOrders(page: state.page + 1);
      emit(MainSourceOrdersState(
        orders: [...state.orders, ...next.items],
        loaded: true,
        page: state.page + 1,
        hasMore: next.hasMore,
        total: next.total,
      ));
    } catch (_) {
      emit(MainSourceOrdersState(
        orders: state.orders,
        loaded: true,
        page: state.page,
        hasMore: state.hasMore,
        total: state.total,
      ));
    }
  }
}
