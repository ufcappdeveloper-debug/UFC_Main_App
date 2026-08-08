import 'package:dio/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/failure/failure.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/product_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/product_data_sourse.dart';

import '../../domain/entities/product/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductsListModel?> getProducts(ProductListQueryParams params) async {
    try {
      final result = await remoteDataSource.getProducts(params.toJson());

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel?> getProductById(int id, int userId) {
    return remoteDataSource.getProductById(id, userId); // ✅ Correct
  }


  @override
  Future<bool> addOrRemoveFavProduct(int productId) async {
    try {
      final result = await remoteDataSource.addOrRemoveFavProduct(productId);

      return result;
    } on DioException catch (e) {
      throw NetworkFailure(e.response?.data.toString() ?? "Network error");
    } catch (e) {
      throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    }
  }
}
