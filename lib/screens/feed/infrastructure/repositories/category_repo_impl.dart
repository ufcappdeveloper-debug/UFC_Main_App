import '../../domain/entities/product/product_category_model.dart';
import '../../domain/repositories/category_repo.dart';
import '../data_sources/category_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CategoryModel>> getCategories(Map<String, dynamic> params) async {
    try {
      return await remoteDataSource.getCategories(params);
    } catch (e) {
      rethrow;
    }
  }
}
