import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/product_service.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

part "product_async_riverpod.g.dart";

@Riverpod(keepAlive: true)
class ProductAsync extends _$ProductAsync {
  @override
  FutureOr<List<ProductModel>?> build({int? categoryId}) async {
    return null;
  }

  Future<void> getProducts(
    final int? shopId,
    final int? categoryId, {
    final int? sort,
    final int? size,
    final int? isOffer,
    final int? minPrice,
    final int? maxPrice,
    final String? search,
    final int? createdWithin,
    final String? productType,
    final List<int>? animalType,
  }) async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 20,
      "shop_id": shopId,
      if (sort != null) "sort": sort,
      if (search != null) "search": search,
      if (categoryId != null) "category_id": categoryId,
      if (productType != null) "product_type": productType,
      if (size != null) "size": size,
      if (minPrice != null) "min_price": minPrice,
      if (maxPrice != null) "max_price": maxPrice,
      if (createdWithin != null) "created_within": createdWithin,
      if (isOffer != null) "is_offer": isOffer,
      if (animalType != null) "product_subtypes_relations": animalType,
    };
    try {
      state = AsyncValue.data(await ProductService().getProducts(data));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> loadProducts(
    final int page,
    final int? shopId,
    final int? categoryId, {
    final int? sort,
    final int? size,
    final int? isOffer,
    final int? minPrice,
    final int? maxPrice,
    final String? search,
    final int? createdWithin,
    final String? productType,
    final List<int>? animalType,
  }) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": 20,
      "shop_id": shopId,
      if (sort != null) "sort": sort,
      if (search != null) "search": search,
      if (categoryId != null) "category_id": categoryId,
      if (productType != null) "product_type": productType,
      if (size != null) "size": size,
      if (minPrice != null) "min_price": minPrice,
      if (maxPrice != null) "max_price": maxPrice,
      if (createdWithin != null) "created_within": createdWithin,
      if (isOffer != null) "is_offer": isOffer,
      if (animalType != null) "product_subtypes_relations": animalType,
    };
    try {
      List<ProductModel> result = await ProductService().getProducts(data);
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
