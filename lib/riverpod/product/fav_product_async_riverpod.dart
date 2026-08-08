import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/product_service.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part "fav_product_async_riverpod.g.dart";

@Riverpod(keepAlive: true)
class FavProductAsync extends _$FavProductAsync {
  @override
  FutureOr<List<ProductModel>?> build() async {
    return null;
  }

  Future<bool> addOrRemoveFavProduct(
      {final int? productId, final ProductModel? productData}) async {
    // Ensure that either productId or productData is provided, but not both
    assert((productId != null && productData == null) ||
        (productId == null && productData != null));

    try {
      final id = productId ?? productData?.id;

      if (id == null) throw 'Something went wrong. Product not found.';

      // Safely perform the add/remove operation
      final result = await ProductService().addOrRemoveFavProduct(id);

      if (productData != null && !isListEmpty(state.value)) {
        if (result) {
          state.value?.insert(0, productData);
        } else {
          state.value?.removeWhere((element) => element.id == productData.id);
        }
        state = AsyncValue.data(state.value);
      }

      return result;
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      log(e.toString());
      throw e.toString();
    }
  }

  Future<void> getFavProductList(final String favSelectedFilter) async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 20,
      "stock": favSelectedFilter == "In Stock" ? 1 : 0,
    };
    try {
      state = AsyncValue.data(await ProductService().getFavProductList(data));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> loadFavProductList(
      final int page, final String favSelectedFilter) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": 20,
      "stock": favSelectedFilter == "In Stock" ? 1 : 0,
    };
    try {
      List<ProductModel> result =
          await ProductService().getFavProductList(data);
      if (result.isEmpty) {
        return "empty";
      }

      state.value?.addAll(result);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
    return null;
  }
}
