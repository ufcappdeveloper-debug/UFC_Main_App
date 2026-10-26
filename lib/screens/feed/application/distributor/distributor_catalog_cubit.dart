import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/distributor/distributor_category_model.dart';
import '../../domain/entities/distributor/distributor_model.dart';
import '../../domain/entities/distributor/distributor_product_model.dart';
import '../../domain/entities/distributor/distributor_query_params.dart';
import '../../domain/repositories/distributor_repo.dart';
import '../../infrastructure/data_sources/distributor/distributor_data_source.dart';

class DistributorCatalogState extends Equatable {
  final DistributorModel? distributor;
  final List<DistributorCategoryModel> categories;
  final List<DistributorProductModel> products;

  /// null = "All".
  final int? selectedCategoryId;
  final bool loading;
  final bool loadingProducts;
  final bool loadingMore;
  final bool hasMore;
  final String? error;
  final DistributorProductParams? params;

  const DistributorCatalogState({
    this.distributor,
    this.categories = const [],
    this.products = const [],
    this.selectedCategoryId,
    this.loading = false,
    this.loadingProducts = false,
    this.loadingMore = false,
    this.hasMore = false,
    this.error,
    this.params,
  });

  DistributorCatalogState copyWith({
    DistributorModel? distributor,
    List<DistributorCategoryModel>? categories,
    List<DistributorProductModel>? products,
    int? selectedCategoryId,
    bool clearCategory = false,
    bool? loading,
    bool? loadingProducts,
    bool? loadingMore,
    bool? hasMore,
    String? error,
    DistributorProductParams? params,
  }) =>
      DistributorCatalogState(
        distributor: distributor ?? this.distributor,
        categories: categories ?? this.categories,
        products: products ?? this.products,
        selectedCategoryId: clearCategory
            ? null
            : (selectedCategoryId ?? this.selectedCategoryId),
        loading: loading ?? this.loading,
        loadingProducts: loadingProducts ?? this.loadingProducts,
        loadingMore: loadingMore ?? this.loadingMore,
        hasMore: hasMore ?? this.hasMore,
        error: error,
        params: params ?? this.params,
      );

  @override
  List<Object?> get props => [
        distributor?.id,
        distributor?.isOpen,
        categories,
        products,
        selectedCategoryId,
        loading,
        loadingProducts,
        loadingMore,
        hasMore,
        error,
      ];
}

/// Distributor page: header details, category chips and the product grid.
class DistributorCatalogCubit extends Cubit<DistributorCatalogState> {
  final DistributorRepository repository;

  DistributorCatalogCubit(this.repository)
      : super(const DistributorCatalogState());

  Future<void> open(DistributorModel distributor) async {
    if (state.distributor?.id == distributor.id && state.categories.isNotEmpty) {
      return;
    }
    emit(DistributorCatalogState(distributor: distributor, loading: true));
    final params = DistributorProductParams(distributorId: distributor.id!);
    try {
      final results = await Future.wait<Object>([
        repository.getDistributorDetail(distributor.id!),
        repository.getCategories(distributor.id!),
        repository.getProducts(params),
      ]);
      final detail = results[0] as DistributorModel;
      final categories = results[1] as List<DistributorCategoryModel>;
      final page = results[2] as Paginated<DistributorProductModel>;
      emit(state.copyWith(
        loading: false,
        distributor: detail,
        categories: categories,
        products: page.items,
        hasMore: page.hasMore,
        params: params,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString(), params: params));
    }
  }

  Future<void> refresh() async {
    final distributor = state.distributor;
    if (distributor == null) return;
    emit(const DistributorCatalogState());
    await open(distributor);
  }

  Future<void> selectCategory(int? categoryId) async {
    final base = state.params;
    if (base == null) return;
    final params = categoryId == null
        ? base.copyWith(page: 1, clearCategory: true)
        : base.copyWith(page: 1, categoryId: categoryId);
    emit(state.copyWith(
      selectedCategoryId: categoryId,
      clearCategory: categoryId == null,
      loadingProducts: true,
      products: [],
      params: params,
    ));
    await _fetch(params);
  }

  Future<void> search(String query) async {
    final base = state.params;
    if (base == null) return;
    final params = base.copyWith(page: 1, search: query);
    emit(state.copyWith(loadingProducts: true, products: [], params: params));
    await _fetch(params);
  }

  Future<void> applyFilter(DistributorProductParams params) async {
    emit(state.copyWith(
        loadingProducts: true, products: [], params: params));
    await _fetch(params);
  }

  Future<void> _fetch(DistributorProductParams params) async {
    try {
      final page = await repository.getProducts(params);
      emit(state.copyWith(
        loadingProducts: false,
        products: page.items,
        hasMore: page.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(loadingProducts: false, error: e.toString()));
    }
  }

  Future<void> loadMore() async {
    final base = state.params;
    if (base == null || !state.hasMore || state.loadingMore) return;
    final params = base.copyWith(page: base.page + 1);
    emit(state.copyWith(loadingMore: true, params: params));
    try {
      final page = await repository.getProducts(params);
      emit(state.copyWith(
        loadingMore: false,
        products: [...state.products, ...page.items],
        hasMore: page.hasMore,
      ));
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e.toString()));
    }
  }

  /// Optimistically flips the heart on a product in the grid.
  Future<void> toggleFavorite(DistributorProductModel product) async {
    if (product.id == null) return;
    product.favorite = !product.favorite;
    emit(state.copyWith(products: [...state.products]));
    try {
      product.favorite = await repository.toggleFavorite(product.id!);
    } catch (_) {
      product.favorite = !product.favorite;
    }
    emit(state.copyWith(products: [...state.products]));
  }
}
