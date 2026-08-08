import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/feed/application/payment/payment_cubit.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/payment_repo.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/payment_usecase.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/payment/payment_data_source.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/payment/payment_data_source_impl.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/repositories/payment_repo.impl.dart';

final sl = GetIt.instance;

void registerPaymentModule() {
  // Cubit
  sl.registerFactory(() => PaymentCubit(
        sl(),
      ));

  // Use case
  sl.registerLazySingleton(() => GetBankDetailsUseCase(sl()));
//  sl.registerLazySingleton(() => UpdateSadadUserInfoUseCase(sl()));

  // Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl()),
  );

  // Data source
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(sl()),
  );
}
