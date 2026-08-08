import 'package:ufc_mobile/global/shared/init/injection.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/apple_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/auto_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/edit_email_phone_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/email_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/google_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/register_email_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/reset_password_email_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/twitter_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/update_password.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/verify_new_email_phone_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/verify_reset_password_usecase.dart';

import '../../../screens/feed/application/authentication/auth_cubit.dart';
import '../../../screens/feed/domain/repositories/authentication_repo.dart';
import '../../../screens/feed/domain/usecases/delete_account_usecase.dart';
import '../../../screens/feed/domain/usecases/edit_user_usecase.dart';
import '../../../screens/feed/domain/usecases/get_profile_usecase.dart';
import '../../../screens/feed/domain/usecases/logout_usecase.dart';
import '../../../screens/feed/domain/usecases/request_otp_usecase.dart';
import '../../../screens/feed/domain/usecases/verify_otp_usecase.dart';
import '../../../screens/feed/infrastructure/data_sources/authentication/auth_data_sourse.dart';
import '../../../screens/feed/infrastructure/data_sources/authentication/auth_data_sourse_impl.dart';
import '../../../screens/feed/infrastructure/repositories/auth_repo_impl.dart';

void registerAuthModule() {
  // ✅ DataSource
  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl());

  // ✅ Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepoImpl(sl()));

  // ✅ UseCases
  sl.registerLazySingleton(() => RequestOtpUsecase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUsecase(sl()));
  sl.registerLazySingleton(() => GetProfileUsecase(sl()));
  sl.registerLazySingleton(() => EditUserUsecase(sl()));
  sl.registerLazySingleton(() => AutoLoginUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(sl()));
  sl.registerLazySingleton(() => EditEmailPhoneUsecase(sl()));
  sl.registerLazySingleton(() => VerifyNewEmailPhoneUsecase(sl()));
  sl.registerLazySingleton(() => GoogleLoginUsecase(sl()));
  sl.registerLazySingleton(() => TwitterLoginUsecase(sl()));
  sl.registerLazySingleton(() => AppleLoginUsecase(sl()));
  sl.registerLazySingleton(() => EmailLoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterEmailUsecase(sl()));
  sl.registerLazySingleton(() => ResetPasswordEmailUsecase(sl()));
  sl.registerLazySingleton(() => VerifyResetPasswordUsecase(sl()));
  sl.registerLazySingleton(() => UpdatePasswordUsecase(sl()));

  // ✅ Cubit
  sl.registerFactory(
      () => AuthCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
}
