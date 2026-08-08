import '../entities/product/product_model.dart';
import '../repositories/product_repo.dart';

class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<ProductModel?> call(int productId, int userId) {
    return repository.getProductById(productId, userId);
  }
}
