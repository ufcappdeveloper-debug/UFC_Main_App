import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/rating_service.dart';
import 'package:ufc_mobile/models/rating_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part "rating_async_riverpod.g.dart";

@Riverpod(keepAlive: true)
class RatingAsync extends _$RatingAsync {
  @override
  FutureOr<List<RatingModel>?> build() async {
    return null;
  }

  Future<bool> addProductRating(final data) async {
    try {
      return await RatingService().addProductRating(data);
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      log(e.toString());
      throw e.toString();
    }
  }

  Future<void> getProductRating(final int? productId) async {
    state = const AsyncValue.loading();
    final Map<String, dynamic> data = {
      "page": 1,
      "limit": 20,
    };
    try {
      state = AsyncValue.data(
          await RatingService().getProductRating(productId, data));
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<String?> loadProductRating(final int page, final int productId) async {
    final Map<String, dynamic> data = {
      "page": page,
      "limit": 20,
    };
    try {
      List<RatingModel> result =
          await RatingService().getProductRating(productId, data);
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
