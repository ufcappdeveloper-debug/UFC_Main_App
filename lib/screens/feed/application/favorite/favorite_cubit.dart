import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_list_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/favorite/favorite_query_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/screens/feed/domain/failure/failure.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/add_product_to_fav.dart';

import '../../../../global/util/exception/error_handler.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final AddProductToFavoritesUseCase addProductToFavoritesUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  FavoriteCubit(this.addProductToFavoritesUseCase, this.getFavoritesUseCase)
      : super(FavoriteInitial());

  final List<ProductModel> favorites = [];

  FavoriteListModel? pagination;

  FavoriteQueryParams _currentParams = const FavoriteQueryParams();

  Future<void> getFavProductList({FavoriteQueryParams? params}) async {
    emit(FavoriteLoading());

    _currentParams = params ?? _currentParams.copyWith(page: 1);

    try {
      final response = await getFavoritesUseCase(_currentParams.toJson());

      // Update list and pagination
      favorites
        ..clear()
        ..addAll(response?.data ?? []);
      pagination = response;

      emit(FavoriteLoaded(
        products: favorites,
        currentPage: pagination?.currentPage ?? 1,
        lastPage: pagination?.lastPage ?? 1,
        hasReachedEnd:
            (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
      ));
    } on Failure catch (f) {
      emit(FavoriteError(f.message));
    } catch (e) {
      emit(FavoriteError(ErrorHandler.getErrorMessage(e)));
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
      final response = await getFavoritesUseCase(_currentParams.toJson());

      // Append new data
      favorites.addAll(response?.data ?? []);
      pagination = response;

      emit(FavoriteLoaded(
        products: favorites,
        currentPage: pagination?.currentPage ?? 1,
        lastPage: pagination?.lastPage ?? 1,
        hasReachedEnd:
            (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
      ));
    } on Failure catch (f) {
      emit(FavoriteError(f.message));
    } catch (e) {
      emit(FavoriteError(ErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> updateParams({String? type, double? size, double? price}) async {
    FavoriteQueryParams params = FavoriteQueryParams(shopId: _currentParams.shopId, productType: type, size: size, maxPrice: price);
    await getFavProductList(params: params);
  }

  Future<void> addOrRemoveFavProduct(int productId) async {
    try {
      emit(FavoriteLoading());

      final bool isFavoriteNow = await addProductToFavoritesUseCase(productId);

      emit(FavoriteActionSuccess(isFavoriteNow, productId));
    } catch (e) {
      emit(FavoriteError(ErrorHandler.getErrorMessage(e)));
    }
  }

  void toggleFavorite(int productId, BuildContext context) async {
    emit(FavoriteAddRemLoad());
    final index = favorites.indexWhere((p) => p.id == productId);
    if (index == -1) return;
    final bool result = await addProductToFavoritesUseCase.call(productId);
    if(result){
        favorites.removeAt(index);
    }
    emit(FavoriteLoaded(
      products: favorites,
      currentPage: pagination?.currentPage ?? 1,
      lastPage: pagination?.lastPage ?? 1,
      hasReachedEnd:
          (pagination?.currentPage ?? 1) >= (pagination?.lastPage ?? 1),
      toggleFavMsg: 'Favorite removed successfully'
    ));
  
  }
}
