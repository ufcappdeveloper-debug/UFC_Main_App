import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/farm/application/barn_details/barn_details_cubit.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/barn_repo.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/barn_details_usecase.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/barn/barn_data_scource_impl.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/barn/barn_data_sourse.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/repositories/barn_repo_impl.dart';

import '../../../screens/farm/domain/usecase/update_feed_quantity_usecase.dart';

final sl = GetIt.instance;

void registerBarnModule() {
  // Cubit
  sl.registerFactory(() => BarnDetailsCubit(sl(), sl()));

  // Use case
  sl.registerLazySingleton(() => GetBarnDetailsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFeedQuantityUsecase(sl()));

  // Repository
  sl.registerLazySingleton<BarnRepository>(
    () => BarnRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<BarnRemoteDataSource>(
    () => BarnRemoteDataSourceImpl(),
  );
}
