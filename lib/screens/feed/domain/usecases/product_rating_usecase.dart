// domain/usecases/get_product_ratings_usecase.dart

import '../entities/product/product_rating_model.dart';
import '../repositories/product_rating_repo.dart';

class GetProductRatingsUseCase {
  final ProductRatingRepository repository;

  GetProductRatingsUseCase(this.repository);

  Future<List<ReviewModel>> call({
    required int productId,
    int page = 1,
    int limit = 10,
  }) {
    return repository.getProductRatings(
      productId: productId,
      page: page,
      limit: limit,
    );
  }
}
