import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/application/notification/notification_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/notification_usecase.dart';

import '../../../screens/feed/domain/repositories/notification_repo.dart';
import '../../../screens/feed/infrastructure/data_sources/notification_data_source.dart';
import '../../../screens/feed/infrastructure/data_sources/notification_data_source_impl.dart';
import '../../../screens/feed/infrastructure/repositories/notification_repo_impl.dart';

final sl = GetIt.instance;

void registerNotificationModule() {
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(
      () => api
    );
  }

  // ✅ DataSource
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );

  // ✅ Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );

  // ✅ UseCases
  sl.registerLazySingleton(() => GetUserNotificationsUseCase(sl()));

  // ✅ Cubit (inject all 5 use cases now)
  sl.registerFactory(
    () => NotificationCubit(
      sl<GetUserNotificationsUseCase>(),
    ),
  );
}
