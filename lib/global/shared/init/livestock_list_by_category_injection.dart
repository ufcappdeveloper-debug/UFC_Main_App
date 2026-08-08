import 'package:get_it/get_it.dart';
import '../../../screens/farm/domain/usecase/livestock_list_by_category_usecase.dart';

final sl = GetIt.instance;

void registerLivestockList() {
  // Cubit
  // sl.registerFactory(() => LivestockListByCategoryCubit(sl()));

  // Use case
  sl.registerLazySingleton(() => LivestockListByCategoryUseCase(sl()));
}
