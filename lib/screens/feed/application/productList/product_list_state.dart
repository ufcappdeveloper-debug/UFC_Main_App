import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

abstract class ProductListState {}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoadingPartial extends ProductListState {
  final List<ProductModel> existingProducts;

  ProductListLoadingPartial(this.existingProducts);
}

class ProductListLoaded extends ProductListState {
  final List<ProductModel> products;
  final ProductModel? singleProduct;
  final int currentPage;
  final int lastPage;
  final bool hasReachedEnd;
  final String? toggleFavMsg;

  ProductListLoaded({
    this.products = const [],
    this.singleProduct,
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasReachedEnd = true,
    this.toggleFavMsg,
  });
}

class ProductListError extends ProductListState {
  final Object message;

  ProductListError(this.message);
}
