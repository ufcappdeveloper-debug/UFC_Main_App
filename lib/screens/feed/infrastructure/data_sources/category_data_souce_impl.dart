import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../../global/config/config.dart';
import '../../domain/entities/product/product_category_model.dart';
import 'category_data_source.dart';


class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;
  CategoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CategoryModel>> getCategories(Map<String, dynamic> params) async {
    debugPrint("📡 [CategoryRemoteDataSourceImpl] Fetching categories with params: $params");

    try {
      final response = await api.get(
        "/api/ufc/v1/categories/search",
        queryParameters: params,
        options: Options(headers: {
          "Authorization": "Bearer ${AppConfig.token}",
        }),
      );

      debugPrint("✅ Response status for catgeo: ${response.statusCode}");
      debugPrint("📦 Raw response data: ${response.data}");
      if (response.statusCode == 200) {
        final raw = response.data;
        final list = (raw["categories"]?["data"] ?? []) as List;
        debugPrint("📊 Parsed categories count: ${list.length}");
        return list.map((json) => CategoryModel.fromJson(json)).toList();
      }

      else {
        debugPrint("⚠️ Non-200 response: ${response.statusCode}");
        throw Exception("Failed to load categories: ${response.statusCode}");
      }
    } catch (e, stack) {
      debugPrint("💥 Exception in getCategories: $e");
      debugPrint("📍 Stacktrace: $stack");
      rethrow;
    }
  }
}
