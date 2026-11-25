import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/main_source/main_source_api_exception.dart';
import '../../domain/entities/main_source/main_source_product_model.dart';
import '../../domain/repositories/main_source_repo.dart';

class MainSourceProductDetailsState extends Equatable {
  final MainSourceProductModel? product;
  final bool loading;
  final Object? error;

  const MainSourceProductDetailsState({
    this.product,
    this.loading = false,
    this.error,
  });

  /// 404: the product, its category or its source was hidden.
  bool get notFound =>
      error is MainSourceApiException &&
      (error as MainSourceApiException).isNotFound;

  @override
  List<Object?> get props => [product?.id, product?.variants.length, loading,
        error?.toString()];
}

class MainSourceProductDetailsCubit
    extends Cubit<MainSourceProductDetailsState> {
  final MainSourceRepository repository;

  MainSourceProductDetailsCubit(this.repository)
      : super(const MainSourceProductDetailsState());

  Future<void> load(int productId, {MainSourceProductModel? initial}) async {
    emit(MainSourceProductDetailsState(product: initial, loading: true));
    try {
      final product = await repository.getProduct(productId);
      emit(MainSourceProductDetailsState(product: product));
    } catch (e) {
      final notFound = e is MainSourceApiException && e.isNotFound;
      emit(MainSourceProductDetailsState(
          product: notFound ? null : initial, error: e));
    }
  }
}
