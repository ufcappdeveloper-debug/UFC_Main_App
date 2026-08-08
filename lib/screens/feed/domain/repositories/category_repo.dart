import '../entities/product/product_category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories(Map<String, dynamic> params);
}