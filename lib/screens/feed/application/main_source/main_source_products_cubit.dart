import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/main_source/main_source_params.dart';
import '../../domain/entities/main_source/main_source_product_model.dart';
import '../../domain/repositories/main_source_repo.dart';

class MainSourceProductsState extends Equatable {
  final MainSourceProductParams params;
  final List<MainSourceProductModel> products;
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final int total;
  final Object? error;

  const MainSourceProductsState({
    this.params = const MainSourceProductParams(),
    this.products = const [],
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = false,
    this.total = 0,
    this.error,
  });

  MainSourceProductsState copyWith({
    MainSourceProductParams? params,
    List<MainSourceProductModel>? products,
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    int? total,
    Object? error,
  }) =>
      MainSourceProductsState(
        params: params ?? this.params,
        products: products ?? this.products,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        hasMore: hasMore ?? this.hasMore,
        total: total ?? this.total,
        error: error,
      );

  @override
  List<Object?> get props => [
        params.categoryId,
        params.search,
        params.sort,
        params.inStockOnly,
        params.page,
        products.map((e) => e.id).join(','),
        loading,
        loadingMore,
        hasMore,
        total,
        error?.toString(),
      ];
}

/// Main Source product list: search, category, sort, in-stock filter,
/// pull-to-refresh and infinite scroll (plan §2).
class MainSourceProductsCubit extends Cubit<MainSourceProductsState> {
  final MainSourceRepository repository;

  /// Drops results of requests replaced by a newer filter.
  int _request = 0;

  MainSourceProductsCubit(this.repository)
      : super(const MainSourceProductsState());

  Future<void> load([MainSourceProductParams? params]) async {
    final p = (params ?? state.params).copyWith(page: 1);
    final id = ++_request;
    emit(state.copyWith(params: p, loading: true, loadingMore: false));
    try {
      final page = await repository.getProducts(p);
      if (id != _request) return;
      emit(state.copyWith(
        params: p,
        products: page.items,
        loading: false,
        hasMore: page.hasMore,
        total: page.total,
      ));
    } catch (e) {
      if (id != _request) return;
      emit(state.copyWith(loading: false, products: const [], error: e));
    }
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;
    final p = state.params.copyWith(page: state.params.page + 1);
    final id = _request;
    emit(state.copyWith(loadingMore: true));
    try {
      final page = await repository.getProducts(p);
      if (id != _request) return;
      emit(state.copyWith(
        params: p,
        products: [...state.products, ...page.items],
        loadingMore: false,
        hasMore: page.hasMore,
        total: page.total,
      ));
    } catch (e) {
      if (id != _request) return;
      // Keep what is shown; the next scroll retries.
      emit(state.copyWith(loadingMore: false));
    }
  }

  Future<void> search(String text) =>
      load(state.params.copyWith(search: () => text.trim().isEmpty ? null : text));

  Future<void> selectCategory(int? categoryId) {
    if (categoryId == state.params.categoryId && state.products.isNotEmpty) {
      return Future.value();
    }
    return load(state.params.copyWith(categoryId: () => categoryId));
  }

  Future<void> setSort(String? sort, {bool? inStockOnly}) => load(state.params
      .copyWith(sort: () => sort, inStockOnly: inStockOnly));
}
