import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../screens/feed/application/address/address_cubit.dart';
import '../../../screens/feed/domain/repositories/address_repo.dart';
import '../../../screens/feed/domain/usecases/address_usecase.dart';
import '../../../screens/feed/infrastructure/data_sources/address_data_source.dart';
import '../../../screens/feed/infrastructure/data_sources/address_data_source_impl.dart';
import '../../../screens/feed/infrastructure/repositories/address_repo_impl.dart';

final sl = GetIt.instance;

void registerAddressModule() {
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(
          () => api
    );
  }

  // ✅ DataSource
  sl.registerLazySingleton<AddressRemoteDataSource>(
        () => AddressRemoteDataSourceImpl(sl()),
  );

  // ✅ Repository
  sl.registerLazySingleton<AddressRepository>(
        () => AddressRepositoryImpl(sl()),
  );

  // ✅ UseCases
  sl.registerLazySingleton(() => GetAddressesUseCase(sl()));
  sl.registerLazySingleton(() => SetDefaultAddressUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAddressUseCase(sl()));
  sl.registerLazySingleton(() => CreateAddressUseCase(sl())); // ✅ added
  sl.registerLazySingleton(() => GetDefaultAddressUseCase(sl())); 

  // ✅ Cubit (inject all 5 use cases now)
  sl.registerFactory(
        () => AddressCubit(
      sl<GetAddressesUseCase>(),
      sl<DeleteAddressUseCase>(),
      sl<UpdateAddressUseCase>(),
      sl<SetDefaultAddressUseCase>(),
      sl<CreateAddressUseCase>(),
      sl<GetDefaultAddressUseCase>(), // ✅ added
    ),
  );
}
