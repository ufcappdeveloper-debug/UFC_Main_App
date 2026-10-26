import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/distributor/distributor_product_model.dart';
import '../../domain/repositories/distributor_repo.dart';

class DistributorProductDetailsState extends Equatable {
  final DistributorProductModel? product;
  final bool loading;
  final String? error;

  /// Bumped on every change so Equatable sees mutations (e.g. favorite).
  final int version;

  const DistributorProductDetailsState({
    this.product,
    this.loading = false,
    this.error,
    this.version = 0,
  });

  @override
  List<Object?> get props => [product?.id, loading, error, version];
}

class DistributorProductDetailsCubit
    extends Cubit<DistributorProductDetailsState> {
  final DistributorRepository repository;

  DistributorProductDetailsCubit(this.repository)
      : super(const DistributorProductDetailsState());

  Future<void> load(int productId, {DistributorProductModel? initial}) async {
    emit(DistributorProductDetailsState(product: initial, loading: true));
    try {
      final product = await repository.getProduct(productId);
      emit(DistributorProductDetailsState(product: product));
    } catch (e) {
      emit(DistributorProductDetailsState(
          product: initial, error: e.toString()));
    }
  }

  Future<void> toggleFavorite() async {
    final product = state.product;
    if (product?.id == null) return;
    product!.favorite = !product.favorite;
    emit(DistributorProductDetailsState(
        product: product, version: state.version + 1));
    try {
      product.favorite = await repository.toggleFavorite(product.id!);
    } catch (_) {
      product.favorite = !product.favorite;
    }
    emit(DistributorProductDetailsState(
        product: product, version: state.version + 1));
  }
}
