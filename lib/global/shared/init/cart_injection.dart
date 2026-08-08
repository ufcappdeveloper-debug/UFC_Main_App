// global/shared/init/cart_injection.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/application/cart/cart_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/cart_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/cart_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/cart_data_source_impl.dart';

import '../../../screens/feed/domain/usecases/cart_usecase.dart';
import '../../../screens/feed/infrastructure/repositories/cart_repo_impl.dart';

final sl = GetIt.instance;

// global/shared/init/cart_injection.dart
void registerCartModule() {
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(
        () => api);
  }

  // DataSource
  sl.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => GetCartCountUseCase(sl()));
  sl.registerLazySingleton(() => IncrementQuantityUseCase(sl()));
  sl.registerLazySingleton(() => DecrementQuantityUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));
  sl.registerLazySingleton(() => AddPastOrdersUseCase(sl()));

  // Cubit
  sl.registerFactory(
      () => CartCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
}
