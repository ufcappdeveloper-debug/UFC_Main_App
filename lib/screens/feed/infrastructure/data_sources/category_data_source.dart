

import '../../domain/entities/product/product_category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories(Map<String, dynamic> params);
}
