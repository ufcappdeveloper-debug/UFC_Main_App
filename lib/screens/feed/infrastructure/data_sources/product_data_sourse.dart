import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductsListModel?> getProducts(Map<String, dynamic> params);
  Future<bool> addOrRemoveFavProduct(int productId);
  Future<ProductModel?> getProductById(int productId, int userId);
}
