import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../screens/feed/application/contact/contact_cubit.dart';
import '../../../screens/feed/domain/repositories/contact_repo.dart';
import '../../../screens/feed/infrastructure/data_sources/contact_data_souce.dart';
import '../../../screens/feed/infrastructure/data_sources/contact_data_souce_impl.dart';
import '../../../screens/feed/infrastructure/repositories/contact_repo_impl.dart';


final sl = GetIt.instance;

void registerSupportModule() {

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(
          () => api,
    );
  }
  sl.registerLazySingleton<SupportRemoteDataSource>(
          () => SupportRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<SupportRepository>(
          () => SupportRepositoryImpl(sl()));

  sl.registerFactory(() => SupportCubit(sl()));
}
