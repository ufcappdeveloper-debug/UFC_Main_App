
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/feed/application/delivery_cost/delivery_cost_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/delivery_cost_repo.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/delivery_cost_usecase.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/delivery_cost/delivery_cost_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/delivery_cost/delivery_cost_data_source_impl.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/repositories/delivery_cost_repo_impl.dart';

final sl = GetIt.instance;

void registerDeliveryCostModule() {
  // Cubit
  sl.registerFactory(() => DeliveryCostCubit(sl(), ));

  // Use case
  sl.registerLazySingleton(() => CalculateDeliveryCostUseCase(sl()));
  

  // Repository
  sl.registerLazySingleton<DeliveryCostRepository>(
    () => DeliveryCostRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<DeliveryCostRemoteDataSource>(
    () => DeliveryCostRemoteDataSourceImpl(),
  );
}
