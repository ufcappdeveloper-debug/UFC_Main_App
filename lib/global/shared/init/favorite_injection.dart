import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/feed/application/favorite/favorite_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/favorite_repo.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/add_product_to_fav.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/favorite/favorite_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/favorite/favorite_data_source_impl.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/repositories/favorite_repo_impl.dart';

final sl = GetIt.instance;

void registerFavoriteModule() {
  // Cubit
  sl.registerFactory(() => FavoriteCubit(sl(), sl()));

  // Use case
  sl.registerLazySingleton(() => AddProductToFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSourceImpl(),
  );
}
