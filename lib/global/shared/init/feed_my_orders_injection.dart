import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/feed/application/my_orders/my_orders_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/my_orders_repo.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/my_orders_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/order_details_usecase.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/my_orders_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/my_orders_data_source_impl.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/repositories/my_orders_repo_impl.dart';

final sl = GetIt.instance;

void registerOrderModule() {
  // Cubit
  sl.registerFactory(() => MyOrdersCubit(sl(), sl()));

  //Use case
 sl.registerLazySingleton(() => GetMyOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(sl()));

  // // Repository
  sl.registerLazySingleton<MyOrdersRepository>(
    () => MyOrdersRepositoryImpl(sl()),
  );

  // // Data source
  sl.registerLazySingleton<MyOrdersRemoteDataSource>(
    () => MyOrdersRemoteDataSourceImpl(sl()),
  );
}
