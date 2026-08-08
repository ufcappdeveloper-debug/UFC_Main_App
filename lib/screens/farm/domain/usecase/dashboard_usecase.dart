import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_resp_model.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/dashboard_repo.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<DashboardResponseModel> call({
    String? filterKey,
  }) {
    return repository.getDashboardDetails(filterKey: filterKey);
  }
}
