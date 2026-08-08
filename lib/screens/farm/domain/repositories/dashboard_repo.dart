import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_resp_model.dart';

abstract class DashboardRepository {
  Future<DashboardResponseModel> getDashboardDetails({
    String? filterKey,
  });
}
