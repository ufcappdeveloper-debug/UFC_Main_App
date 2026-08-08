// data/data_sources/product_rating_remote_data_source.dart

import '../../domain/entities/product/product_rating_model.dart';

abstract class ProductRatingRemoteDataSource {
  Future<List<ReviewModel>> getProductRatings({
    required int productId,
    int page = 1,
    int limit = 10,
  });
  Future<void> addProductRating({
    required int productId,
    required int rating,
    required String review,
  });
}
