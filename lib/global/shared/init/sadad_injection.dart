import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/feed/application/checkout/sadad/sadad_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/sadad_repo.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/sadad_usecase.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/checkout/sadad_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/checkout/sadad_data_source_impl.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/repositories/sadad_repo_impl.dart';

final sl = GetIt.instance;

void registerSadadModule() {
  // Cubit
  sl.registerFactory(() => SadadUserInfoCubit(sl(), sl()));

  // Use case
  sl.registerLazySingleton(() => GetSadadUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSadadUserInfoUseCase(sl()));

  // Repository
  sl.registerLazySingleton<SadadRepository>(
    () =>SadadRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<SadadRemoteDataSource>(
    () => SadadRemoteDataSourceImpl(sl()),
  );
}
