import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/application/station/station_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/station_repo.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/station_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/update_station_usecase.dart'; // ✅ import new usecase
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/station_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/station_data_source_impl.dart';

import '../../../screens/feed/infrastructure/repositories/station_repo_impl.dart';

final sl = GetIt.instance;

void registerStationModule() {

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(
          () => api
    );
  }

  // DataSource
  sl.registerLazySingleton<StationRemoteDataSource>(
        () => StationRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<StationRepository>(
        () => StationRepositoryImpl(sl()),
  );

  // UseCase(s)
  sl.registerLazySingleton(() => GetStationsUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePreferredShopUseCase(sl()));

  // Cubit
  sl.registerFactory(
        () => StationCubit(
      sl<GetStationsUseCase>(),
      sl<UpdatePreferredShopUseCase>(),
    ),
  );
}
