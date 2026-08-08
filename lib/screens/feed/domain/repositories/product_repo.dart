import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_res_model.dart';

import '../entities/product/product_model.dart';

abstract class ProductRepository {
  Future<ProductsListModel?> getProducts(ProductListQueryParams params);
  Future<bool> addOrRemoveFavProduct(int productId);
  Future<ProductModel?> getProductById(int productId, int userId);
}
