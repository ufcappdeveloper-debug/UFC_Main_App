import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/application/wallet/wallet_cubit.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/wallet_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/wallet_data_source_impl.dart';

import '../../../screens/feed/domain/repositories/wallet_repo.dart';
import '../../../screens/feed/domain/usecases/wallet_usecase.dart';
import '../../../screens/feed/infrastructure/repositories/wallet_respo_impl.dart';

final sl = GetIt.instance;

void registerWalletModule() {
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(
          () => api
    );
  }

  // ✅ DataSource
  sl.registerLazySingleton<WalletRemoteDataSource>(
        () => WalletRemoteDataSourceImpl(sl()),
  );

  // ✅ Repository
  sl.registerLazySingleton<WalletRepository>(
        () => WalletRepositoryImpl(sl()),
  );

  // ✅ UseCase
  sl.registerLazySingleton(() => GetWalletTransactionsUseCase(sl()));

  // ✅ Cubit
  sl.registerFactory(() => WalletCubit(sl<GetWalletTransactionsUseCase>()));
}
