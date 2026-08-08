import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/category_service.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_category_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part "category_async_riverpod.g.dart";

@Riverpod(keepAlive: true)
class CategoryAsync extends _$CategoryAsync {
  @override
  FutureOr<List<CategoryModel>?> build() async {
    return null;
  }

  Future<void> getCategories() async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 10,
    };
    try {
      List<CategoryModel> result = await CategoryService().getCategories(data);
      if (result.isNotEmpty) {
        result.insert(0,
            CategoryModel(createdAt: "All", nameEn: "All", nameAr: "الجميع"));
      }

      state = AsyncValue.data(result);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> loadCategories(final int page) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": 10,
    };
    try {
      List<CategoryModel> result = await CategoryService().getCategories(data);
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
