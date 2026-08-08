import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/screens/farm/application/dashbaord/dashboard_cubit.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/dashboard_usecase.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/dashboard/dashboard_datasource_impl.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/repositories/dashboard_repo_impl.dart';

void main() {
  late FarmDashboardCubit cubit;

  setUp(() {
    final remoteDS = DashboardRemoteDataSourceImpl();
    final repository = DashboardRepositoryImpl(remoteDS);
    final useCase = GetDashboardDataUseCase(repository);
    cubit = FarmDashboardCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('fetch dashboard and print', () async {
    await cubit.getDashboardDetails();
    print('Dashboard: ${cubit.state}');
    print(AppConfig.token);
    expect(cubit.state, isNotNull);
  });
}
