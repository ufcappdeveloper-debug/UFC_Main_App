// data/data_sources/product_rating_remote_data_source_impl.dart

import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/product_rating_data_source.dart';

import '../../../../global/config/config.dart';
import '../../domain/entities/product/product_rating_model.dart';

class ProductRatingRemoteDataSourceImpl
    implements ProductRatingRemoteDataSource {
  final Dio dio;

  ProductRatingRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ReviewModel>> getProductRatings({
    required int productId,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await api.get(
      "/api/ufc/v1/public/product/rating/$productId",
      queryParameters: {
        "page": page,
        "limit": limit,
      },
    );

    print("📦 Product Ratings Response: ${response.data}");

    if (response.statusCode == 200) {
      if (response.data != null && response.data["ratings"] != null) {
        final ratingsJson = response.data["ratings"] as List;
        return ratingsJson.map((json) => ReviewModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load product ratings");
    }
  }

  @override
  Future<void> addProductRating({
    required int productId,
    required int rating,
    required String review,
  }) async {
    try {
      final response = await api.post(
        "/api/ufc/v1/product/rating/add",
        data: {
          "product_id": productId,
          "rating": rating,
          "review": review,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${AppConfig.token}",
            "Content-Type": "application/json",
          },
        ),
      );

      print("📬 Add Rating Response: ${response.data}");
      print(
          "📬 Request Data: product_id=$productId, rating=$rating, review=$review");
      print("📬 Response Status: ${response.statusCode}");

      if (response.statusCode != 200) {
        throw Exception("Failed to submit rating");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("❌ DioError Response Status: ${e.response?.statusCode}");
        print("❌ DioError Response Data: ${e.response?.data}");
      } else {
        print("❌ DioError: ${e.message}");
      }
      rethrow;
    }
  }
}
