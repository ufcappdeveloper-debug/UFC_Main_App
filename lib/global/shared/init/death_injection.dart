import 'package:get_it/get_it.dart';

import '../../../screens/farm/application/death/death_cubit.dart';
import '../../../screens/farm/domain/repositories/death_repo.dart';
import '../../../screens/farm/domain/usecase/death_donut_chart_usecase.dart';
import '../../../screens/farm/domain/usecase/death_line_chart_usecase.dart';
import '../../../screens/farm/domain/usecase/death_usecase.dart';
import '../../../screens/farm/infrastructure/data_scourse/death/death_data_source.dart';
import '../../../screens/farm/infrastructure/data_scourse/death/death_data_source_impl.dart';
import '../../../screens/farm/infrastructure/repositories/death_rep_impl.dart';

final sl = GetIt.instance;

void registerDeathModule() {
  // Cubit
  sl.registerFactory(() => DeathCubit(sl(), sl(), sl()));

  // Use case
  sl.registerLazySingleton(() => DeathUsecase(sl()));
  sl.registerLazySingleton(() => DeathDonutChartUsecase(sl()));
  sl.registerLazySingleton(() => DeathLineChartUsecase(sl()));

  // Repository
  sl.registerLazySingleton<DeathRepository>(
    () => DeathRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<DeathDataSource>(
    () => DeathDataSourceImpl(),
  );
}
