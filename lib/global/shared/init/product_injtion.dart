import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';
// Cubit
import 'package:ufc_mobile/screens/feed/application/productList/product_list_cubit.dart';
// Repo & Entities
import 'package:ufc_mobile/screens/feed/domain/repositories/product_repo.dart';
// Usecases
import 'package:ufc_mobile/screens/feed/domain/usecases/add_product_to_fav.dart';
// Data sources
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/product_data_sourse.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/product_data_sourse_impl.dart';
// Repo impl
import 'package:ufc_mobile/screens/feed/infrastructure/repositories/product_repo_impl.dart';

import '../../../screens/feed/domain/usecases/product_by_id_usecase.dart';
import '../../../screens/feed/domain/usecases/product_usecase.dart';

final sl = GetIt.instance;

void registerProductModule() {
  // Dio (could also be registered globally once)
  sl.registerLazySingleton(
    () => api,
  );

  // DataSource
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl()),
  );

  sl.registerLazySingleton<GetProductByIdUseCase>(
      () => GetProductByIdUseCase(sl()));

  // Cubit
  sl.registerFactory<ProductListCubit>(
    () => ProductListCubit(
      sl<GetProductsUseCase>(),
      sl<AddProductToFavoritesUseCase>(),
      sl<GetProductByIdUseCase>(),
    ),
  );
}
