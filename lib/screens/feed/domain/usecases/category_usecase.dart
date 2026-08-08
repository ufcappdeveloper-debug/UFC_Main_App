
import '../entities/product/product_category_model.dart';
import '../repositories/category_repo.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;
  GetCategoriesUseCase(this.repository);

  Future<List<CategoryModel>> call(Map<String, dynamic> params) {
    return repository.getCategories(params);
  }
}
