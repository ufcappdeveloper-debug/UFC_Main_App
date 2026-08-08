import '../../domain/entities/product/product_rating_model.dart';
import '../../domain/repositories/product_rating_repo.dart';
import '../data_sources/product_rating_data_source.dart';

class ProductRatingRepositoryImpl implements ProductRatingRepository {
  final ProductRatingRemoteDataSource remoteDataSource;

  ProductRatingRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ReviewModel>> getProductRatings({
    required int productId,
    int page = 1,
    int limit = 10,
  }) async {
    return await remoteDataSource.getProductRatings(
        productId: productId, page: page, limit: limit);
  }

  @override
  Future<void> addProductRating({
    required int productId,
    required int rating,
    required String review,
  }) async {
    await remoteDataSource.addProductRating(
      productId: productId,
      rating: rating,
      review: review,
    );
  }
}
