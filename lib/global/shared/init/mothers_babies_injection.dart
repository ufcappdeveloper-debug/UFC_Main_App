import 'package:get_it/get_it.dart';

import '../../../screens/farm/application/mothers_babies/mothers_babies_cubit.dart';
import '../../../screens/farm/domain/repositories/mothers_babies_repo.dart';
import '../../../screens/farm/domain/usecase/mothers_and_babies_chart_usecase.dart';
import '../../../screens/farm/domain/usecase/mothers_babies_usecase.dart';
import '../../../screens/farm/infrastructure/data_scourse/mothers_and_babies/mothers_and_babies_data_source.dart';
import '../../../screens/farm/infrastructure/data_scourse/mothers_and_babies/mothers_and_babies_data_source_impl.dart';
import '../../../screens/farm/infrastructure/repositories/mothers_babies_repo_impl.dart';

final sl = GetIt.instance;

void registerMothersBabiesModule() {
  // Cubit
  sl.registerFactory(() => MothersBabiesCubit(sl(), sl()));

  // Use case
  sl.registerLazySingleton(() => MothersBabiesUsecase(sl()));
  sl.registerLazySingleton(() => MothersAndbabiesChartUsecase(sl()));

  // Repository
  sl.registerLazySingleton<MothersBabiesRepoitory>(
    () => MothersBabiesRepoImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<MothersAndBabiesDataSource>(
    () => MothersAndBabiesDataSourceImpl(),
  );
}
