import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../screens/feed/application/business_config/business_config_cubit.dart';
import '../../../screens/feed/application/main_source/main_source_cart_cubit.dart';
import '../../../screens/feed/application/main_source/main_source_home_cubit.dart';
import '../../../screens/feed/application/main_source/main_source_orders_cubit.dart';
import '../../../screens/feed/application/main_source/main_source_product_details_cubit.dart';
import '../../../screens/feed/application/main_source/main_source_products_cubit.dart';
import '../../../screens/feed/domain/repositories/main_source_repo.dart';
import '../../../screens/feed/infrastructure/data_sources/main_source/main_source_data_source.dart';
import '../../../screens/feed/infrastructure/data_sources/main_source/main_source_data_source_impl.dart';
import '../../../screens/feed/infrastructure/repositories/main_source_repo_impl.dart';

final sl = GetIt.instance;

void registerMainSourceModule() {
  // DataSource
  sl.registerLazySingleton<MainSourceRemoteDataSource>(
      () => MainSourceRemoteDataSourceImpl(api));

  // Repository
  sl.registerLazySingleton<MainSourceRepository>(
      () => MainSourceRepositoryImpl(sl()));

  // Cubits
  sl.registerFactory(() => BusinessConfigCubit(sl()));
  sl.registerFactory(() => MainSourceHomeCubit(sl()));
  sl.registerFactory(() => MainSourceProductsCubit(sl()));
  sl.registerFactory(() => MainSourceProductDetailsCubit(sl()));
  sl.registerFactory(() => MainSourceCartCubit(sl()));
  sl.registerFactory(() => MainSourceOrdersCubit(sl()));
}
