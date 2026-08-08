// domain/repositories/product_rating_repository.dart

import '../entities/product/product_rating_model.dart';

abstract class ProductRatingRepository {
  Future<List<ReviewModel>> getProductRatings({
    required int productId,
    int page,
    int limit,
  });

  Future<void> addProductRating({
    required int productId,
    required int rating,
    required String review,
  });
}
