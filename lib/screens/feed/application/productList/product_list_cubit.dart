import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/domain/failure/failure.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/add_product_to_fav.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/product_usecase.dart';

import '../../domain/usecases/product_by_id_usecase.dart';
import 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  final AddProductToFavoritesUseCase? addProductToFavoritesUseCase;

  ProductListCubit(this.getProductsUseCase, this.addProductToFavoritesUseCase,
      this.getProductByIdUseCase)
      : super(ProductListInitial());

  /// Main product list accessible globally
  final List<ProductModel> products = [];

  /// Pagination info
  ProductsListModel? pagination;

  ProductListQueryParams _currentParams = const ProductListQueryParams();

  /// Fetch products initially or with filters
  // Future<void> getProducts(
  //     {ProductListQueryParams? params, bool fromFilter = false}) async {
  //   emit(ProductListLoading());
  //   _currentParams = params ?? _currentParams.copyWith(page: 1);

  //   try {
  //     final response = await getProductsUseCase(_currentParams);

  //     products
  //       ..clear()
  //       ..addAll(response?.data ?? []);
  //     pagination = response;
  //     if (isClosed) return;
  //     emit(ProductListLoaded(
  //       products: products,
  //       singleProduct: null, // ✅ clear single product
  //       currentPage: pagination?.currentPage ?? 1,
  //       lastPage: pagination?.lastPage ?? 1,
  //       hasReachedEnd:
  //           (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
  //     ));
  //   } on Failure catch (f) {
  //     if (isClosed) return;
  //     emit(ProductListError(f.message));
  //   } catch (e) {
  //     if (isClosed) return;
  //     emit(ProductListError(e));
  //   }
  // }

  Future<void> getProducts({
    ProductListQueryParams? params,
    bool fromFilter = false,
    bool keepOldData = false, // new flag
  }) async {
    if (!keepOldData) {
      emit(ProductListLoading());
    } else {
      // Emit a state that keeps the existing products visible but indicates loading
      emit(ProductListLoadingPartial(products));
    }

    _currentParams = params ?? _currentParams.copyWith(page: 1);

    try {
      final response = await getProductsUseCase(_currentParams);

      if (!keepOldData) {
        products
          ..clear()
          ..addAll(response?.data ?? []);
      } else {
        products
          ..clear()
          ..addAll(response?.data ?? []); // or merge with old if needed
      }

      pagination = response;
      if (isClosed) return;

      emit(ProductListLoaded(
        products: products,
        singleProduct: null,
        currentPage: pagination?.currentPage ?? 1,
        lastPage: pagination?.lastPage ?? 1,
        hasReachedEnd:
            (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
      ));
    } on Failure catch (f) {
      if (isClosed) return;
      emit(ProductListError(f.message));
    } catch (e) {
      if (isClosed) return;
      emit(ProductListError(e));
    }
  }

  /// Load next page
  Future<void> loadMore() async {
    if (pagination == null ||
        (pagination?.currentPage ?? 0) >= (pagination?.lastPage ?? 0)) {
      return;
    }

    _currentParams =
        _currentParams.copyWith(page: (pagination?.currentPage ?? 0) + 1);

    try {
      final response = await getProductsUseCase(_currentParams);

      // Append new data
      products.addAll(response?.data ?? []);
      pagination = response;

      emit(ProductListLoaded(
        products: products,
        currentPage: pagination?.currentPage ?? 1,
        lastPage: pagination?.lastPage ?? 1,
        hasReachedEnd:
            (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
      ));
    } on Failure catch (f) {
      emit(ProductListError(f.message));
    } catch (e) {
      emit(ProductListError(e));
    }
  }

  Future<void> updateParams({
    int? categoryId,
    String? type,
    double? size,
    double? price,
  }) async {
    ProductListQueryParams params = ProductListQueryParams(
        categoryId: categoryId,
        shopId: _currentParams.shopId,
        userId: _currentParams.userId,
        productType: type,
        size: size,
        maxPrice: price);

    // 🔹 Keep old products visible while fetching new ones
    await getProducts(params: params, fromFilter: true, keepOldData: true);
  }

  Future<void> getProductById(int productId, int userId) async {
    print('DATA --');
    emit(ProductListLoading());
    print('DATA --1');
    try {
      final product = await getProductByIdUseCase(productId, userId);

      if (product != null) {
        emit(ProductListLoaded(
          singleProduct: product,
          products: [],
          currentPage: 1,
          lastPage: 1,
          hasReachedEnd: true,
        ));
      } else {
        emit(ProductListError("Product not found"));
      }
    } on DioException catch (e) {
      emit(ProductListError(e.dioMessage.toString()));
    } catch (e) {
      emit(ProductListError(e));
    }
  }

  /// Toggle favorite
  void toggleFavorite(int productId) async {
    final index = products.indexWhere((p) => p.id == productId);
    if (index == -1) return;
    final product = products[index];
    final bool result =
        await addProductToFavoritesUseCase?.call(productId) ?? false;
    if (result) {
      final updatedProduct =
          product.copyWith(isFavorite: !(product.isFavorite ?? false));
      products[index] = updatedProduct;
    }
    emit(ProductListLoaded(
        products: products,
        currentPage: pagination?.currentPage ?? 1,
        lastPage: pagination?.lastPage ?? 1,
        hasReachedEnd:
            (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
        toggleFavMsg: !(product.isFavorite ?? false)
            ? 'Favorite added successfully'
            : 'Favorite removed successfully'));
  }
}
