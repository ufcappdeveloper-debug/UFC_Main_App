// global/shared/init/product_rating_injection.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../screens/feed/application/product_rating/rating_cubit.dart';
import '../../../screens/feed/domain/repositories/product_rating_repo.dart';
import '../../../screens/feed/domain/usecases/add_review_usecase.dart';
import '../../../screens/feed/domain/usecases/product_rating_usecase.dart';
import '../../../screens/feed/infrastructure/data_sources/product_rating_data_souce_impl.dart';
import '../../../screens/feed/infrastructure/data_sources/product_rating_data_source.dart';
import '../../../screens/feed/infrastructure/repositories/product_rating_repo_impl.dart';

final sl = GetIt.instance;

void registerProductRatingModule() {
  // 1. Dio Client
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(() =>
        api);
  }

  // 2. Data Source
  sl.registerLazySingleton<ProductRatingRemoteDataSource>(
          () => ProductRatingRemoteDataSourceImpl(sl()));

  // 3. Repository
  sl.registerLazySingleton<ProductRatingRepository>(
          () => ProductRatingRepositoryImpl(sl()));

  // 4. UseCases
  sl.registerLazySingleton(() => GetProductRatingsUseCase(sl()));
  sl.registerLazySingleton(() => AddProductRatingUseCase(sl()));

  // 5. Unified Cubit for Get & Add
  sl.registerFactory(() => ProductRatingCubit(sl(), sl()));
}
