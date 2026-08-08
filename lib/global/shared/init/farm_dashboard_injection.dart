import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/farm/application/dashbaord/dashboard_cubit.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/dashboard_repo.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/dashboard_usecase.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/dashboard/dashboard_datasource.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/dashboard/dashboard_datasource_impl.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/repositories/dashboard_repo_impl.dart';

final sl = GetIt.instance;

void registerFarmDashboard() {
  // Cubit
  sl.registerFactory(() => FarmDashboardCubit(sl()));

  // Use case
  sl.registerLazySingleton(() => GetDashboardDataUseCase(sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(),
  );
}
