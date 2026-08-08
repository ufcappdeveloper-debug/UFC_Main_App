import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_resp_model.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/dashboard_repo.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/dashboard/dashboard_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<DashboardResponseModel> getDashboardDetails(
      {String? filterKey}) async {
    final barnModel =
        await remoteDataSource.getDashboardDetails(filterKey: filterKey);
    return barnModel;
  }
}
