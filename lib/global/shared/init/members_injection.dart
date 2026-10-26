import 'package:get_it/get_it.dart';

import '../../../screens/farm/application/members/farm_account_cubit.dart';
import '../../../screens/farm/application/members/members_cubit.dart';
import '../../../screens/farm/infrastructure/data_scourse/members/members_data_source.dart';

final sl = GetIt.instance;

void registerMembersModule() {
  sl.registerLazySingleton<MembersRemoteDataSource>(
      () => MembersRemoteDataSourceImpl());
  sl.registerFactory(() => MembersCubit(sl()));
  sl.registerFactory(() => FarmAccountCubit(sl()));
}
