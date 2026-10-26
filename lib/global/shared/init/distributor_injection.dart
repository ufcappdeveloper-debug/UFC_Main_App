import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../screens/feed/application/distributor/distributor_cart_cubit.dart';
import '../../../screens/feed/application/distributor/distributor_catalog_cubit.dart';
import '../../../screens/feed/application/distributor/distributor_checkout_cubit.dart';
import '../../../screens/feed/application/distributor/distributor_favorite_cubit.dart';
import '../../../screens/feed/application/distributor/distributor_list_cubit.dart';
import '../../../screens/feed/application/distributor/distributor_product_details_cubit.dart';
import '../../../screens/feed/domain/repositories/distributor_repo.dart';
import '../../../screens/feed/infrastructure/data_sources/distributor/distributor_data_source.dart';
import '../../../screens/feed/infrastructure/data_sources/distributor/distributor_data_source_impl.dart';
import '../../../screens/feed/infrastructure/repositories/distributor_repo_impl.dart';

final sl = GetIt.instance;

void registerDistributorModule() {
  // DataSource
  sl.registerLazySingleton<DistributorRemoteDataSource>(
      () => DistributorRemoteDataSourceImpl(api));

  // Repository
  sl.registerLazySingleton<DistributorRepository>(
      () => DistributorRepositoryImpl(sl()));

  // Cubits
  sl.registerFactory(() => DistributorListCubit(sl()));
  sl.registerFactory(() => DistributorCatalogCubit(sl()));
  sl.registerFactory(() => DistributorProductDetailsCubit(sl()));
  sl.registerFactory(() => DistributorCartCubit(sl()));
  sl.registerFactory(() => DistributorCheckoutCubit(sl()));
  sl.registerFactory(() => DistributorFavoriteCubit(sl()));
}
