import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/feed/application/coupon/coupon_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/coupon_repo.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/coupon_usecase.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/coupon/coupon_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/coupon/coupon_data_source_impl.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/repositories/coupon_repo_impl.dart';

final sl = GetIt.instance;

void registerCouponModule() {
  // Cubit
  sl.registerFactory(() => CouponCubit(sl(), sl()));

  // Use case
  sl.registerLazySingleton(() => ValidateCouponUseCase(sl()));
  sl.registerLazySingleton(() => DeliveryCouponUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CouponRepository>(
    () => CouponRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<CouponRemoteDataSource>(
    () => CouponRemoteDataSourceImpl(sl()),
  );
}
