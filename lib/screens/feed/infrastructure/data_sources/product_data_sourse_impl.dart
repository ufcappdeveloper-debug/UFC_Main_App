import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/product_data_sourse.dart';

import '../../../../global/config/config.dart';
import '../../domain/entities/product/product_model.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<ProductsListModel?> getProducts(Map<String, dynamic> params) async {
    try {
      Response response = await api.get(
        "api/ufc/v1/get_products",
        queryParameters: params,
      );
      ProductsListModel? productsListModel =
          ProductListResponseModel.fromJson(response.data).products;

      return productsListModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel?> getProductById(int productId, int userId) async {
    try {
    
      final response = await api.get(
        "api/ufc/v1/product/$productId",
        queryParameters: {
          "user_id": userId,
          "fetch_favorite": 1,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${AppConfig.token}",
          },
        ),
      );

     
      final product = ProductModel.fromJson(response.data['product']);

      

      return product;
    } catch (e) {
      rethrow;
    }
    // } on DioException catch (e) {
    //   print('[❌] DioException: ${e.response?.data}');
    //   throw NetworkFailure(e.response?.data.toString() ?? "Network error");
    // } catch (e) {
    //   print('[❗] Unexpected error: $e');
    //   throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    // }
  }

  @override
  Future<bool> addOrRemoveFavProduct(int productId) async {
    try {
      Response response = await api.get("api/ufc/v1/fav_product/$productId");
      return response.data["message"] == "Favorite added successfully" ||
          response.data["status"] == "success";
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
