import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/product_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/product_by_id_usecase.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/product_data_sourse_impl.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/repositories/product_repo_impl.dart';

void main() {
  late ProductListCubit cubit;

  setUp(() {
    final dio = Dio();
    final remoteDS = ProductRemoteDataSourceImpl(dio);
    final repository = ProductRepositoryImpl(remoteDS);

    // UseCases
    final getProductsUseCase = GetProductsUseCase(repository);
    final getProductByIdUseCase = GetProductByIdUseCase(repository);

    cubit = ProductListCubit(getProductsUseCase, null, getProductByIdUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('fetch products and print', () async {
    await cubit.getProducts();
    print('Products: ${cubit.state}');
    expect(cubit.state, isNotNull);
  });

  // test('fetch product by ID', () async {
  //   const testProductId = 60; // replace with a valid ID from your API
  //   await cubit.getProductById(testProductId);
  //   print('Product by ID: ${cubit.state}');
  //   expect(cubit.state, isNotNull);
  // });
}
