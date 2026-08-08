import 'package:get_it/get_it.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/livestock_repo.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/livestock/livestock_data_source.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/livestock/livestock_data_sourse_impl.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/repositories/livestock_repo_impl.dart';

final sl = GetIt.instance;

// Shared LiveStock repository and data source
void registerLiveStockCore() {
  sl.registerLazySingleton<LiveStockRepository>(
    () => LivestockRepoImpl(sl()),
  );

  sl.registerLazySingleton<LiveStockDetailsDataSource>(
    () => LiveStockDetailsDataSourceImpl(),
  );
}
