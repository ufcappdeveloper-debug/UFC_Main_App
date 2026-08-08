import '../repositories/product_rating_repo.dart';

class AddProductRatingUseCase {
  final ProductRatingRepository repository;

  AddProductRatingUseCase(this.repository);

  Future<void> call({
    required int productId,
    required int rating,
    required String review,
  }) {
    return repository.addProductRating(
      productId: productId,
      rating: rating,
      review: review,
    );
  }
}
