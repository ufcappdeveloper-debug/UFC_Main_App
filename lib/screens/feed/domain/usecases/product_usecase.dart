import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_params.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_list_res_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/product_repo.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<ProductsListModel?> call(ProductListQueryParams params) {
    return repository.getProducts(params);
  }
}
