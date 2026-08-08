import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/farm/application/livestock_details/livestock_details_cubit.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/livestock_details_usecase.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/livestock_reports_usecase.dart';

import '../../../screens/farm/application/get_question/get_question_cubit.dart';
import '../../../screens/farm/domain/usecase/delete_answer.dart';
import '../../../screens/farm/domain/usecase/delete_death_usecase.dart';
import '../../../screens/farm/domain/usecase/delete_livestock_usecase.dart';
import '../../../screens/farm/domain/usecase/delete_vaccine_usecase.dart';
import '../../../screens/farm/domain/usecase/edit_answer_usecase.dart';
import '../../../screens/farm/domain/usecase/edit_vaccine_usecase.dart';
import '../../../screens/farm/domain/usecase/get_question_usecase.dart';
import '../../../screens/farm/domain/usecase/update_death_usecase.dart';

final sl = GetIt.instance;

void registerLiveStockDetails() {
  // Cubit
  sl.registerFactory(() => LiveStockDetailsCubit(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => GetQuestionCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl()));

  // Use case
  sl.registerLazySingleton(() => GetLiveStockDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetLiveSTockReportUseCase(sl()));
  sl.registerLazySingleton(() => DeleteLivestockUsecase(sl()));
  sl.registerLazySingleton(() => GetQuestionUsecase(sl()));
  sl.registerLazySingleton(() => EditAnswerUsecase(sl()));
  sl.registerLazySingleton(() => DeleteAnswer(sl()));
  sl.registerLazySingleton(() => EditVaccineUsecase(sl()));
  sl.registerLazySingleton(() => DeleteVaccineUsecase(sl()));
  sl.registerLazySingleton(() => DeleteDeathUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDeathUsecase(sl()));
}
