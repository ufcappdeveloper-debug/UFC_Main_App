import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/distributor/distributor_product_model.dart';
import '../../domain/repositories/distributor_repo.dart';

class DistributorFavoriteState extends Equatable {
  final List<DistributorProductModel> products;
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final int page;
  final String? error;

  const DistributorFavoriteState({
    this.products = const [],
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = false,
    this.page = 1,
    this.error,
  });

  @override
  List<Object?> get props =>
      [products.map((e) => e.id).join(','), loading, loadingMore, hasMore, page, error];
}

/// Distributor favorites (separate from shop favorites).
class DistributorFavoriteCubit extends Cubit<DistributorFavoriteState> {
  final DistributorRepository repository;

  DistributorFavoriteCubit(this.repository)
      : super(const DistributorFavoriteState());

  Future<void> load() async {
    emit(const DistributorFavoriteState(loading: true));
    try {
      final page = await repository.getFavorites(1);
      emit(DistributorFavoriteState(
          products: page.items, hasMore: page.hasMore));
    } catch (e) {
      emit(DistributorFavoriteState(error: e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore) return;
    emit(DistributorFavoriteState(
        products: state.products,
        page: state.page,
        hasMore: true,
        loadingMore: true));
    try {
      final next = state.page + 1;
      final page = await repository.getFavorites(next);
      emit(DistributorFavoriteState(
        products: [...state.products, ...page.items],
        hasMore: page.hasMore,
        page: next,
      ));
    } catch (e) {
      emit(DistributorFavoriteState(
          products: state.products, page: state.page, error: e.toString()));
    }
  }

  /// Unfavoriting from this list removes the product.
  Future<void> toggle(DistributorProductModel product) async {
    if (product.id == null) return;
    final isFavorite = await repository.toggleFavorite(product.id!);
    if (!isFavorite) {
      emit(DistributorFavoriteState(
        products: state.products.where((e) => e.id != product.id).toList(),
        hasMore: state.hasMore,
        page: state.page,
      ));
    }
  }
}
