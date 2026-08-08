import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../screens/feed/application/category/category_cubit.dart';
import '../../../screens/feed/domain/repositories/category_repo.dart';
import '../../../screens/feed/domain/usecases/category_usecase.dart';
import '../../../screens/feed/infrastructure/data_sources/category_data_souce_impl.dart';
import '../../../screens/feed/infrastructure/data_sources/category_data_source.dart';
import '../../../screens/feed/infrastructure/repositories/category_repo_impl.dart';

final sl = GetIt.instance;

void registerCategoryModule() {
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(
          () => api
    );
  }


  // ✅ DataSource
  sl.registerLazySingleton<CategoryRemoteDataSource>(
        () => CategoryRemoteDataSourceImpl(sl()),
  );

  // ✅ Repository
  sl.registerLazySingleton<CategoryRepository>(
        () => CategoryRepositoryImpl(sl()),
  );

  // ✅ UseCase
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // ✅ Cubit
  sl.registerFactory(
        () => CategoryCubit(sl<GetCategoriesUseCase>()),
  );
}
