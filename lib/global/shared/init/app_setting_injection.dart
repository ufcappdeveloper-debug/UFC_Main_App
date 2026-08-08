import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/feed/application/app_settings/app_setting_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/app_setting_repo.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/app_setting_usecase.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/app_setting/app_setting_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/app_setting/app_setting_data_source_impl.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/repositories/app_setting_repo_impl.dart';

final sl = GetIt.instance;

void registerAppSettingModule() {
  // Cubit
  sl.registerFactory(() => AppSettingCubit(sl()));

  // Use case
  sl.registerLazySingleton(() => GetAppSettingUseCase(sl()));


  // Repository
  sl.registerLazySingleton<AppSettingRepository>(
    () => AppSettingRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<AppSettingRemoteDataSource>(
    () => AppSettingRemoteDataSourceImpl(sl()),
  );
}
