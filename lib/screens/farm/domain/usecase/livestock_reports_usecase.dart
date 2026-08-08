import 'package:ufc_mobile/screens/farm/domain/entities/livestock/livestock_reports_model.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/livestock_repo.dart';

class GetLiveSTockReportUseCase {
  final LiveStockRepository repository;

  GetLiveSTockReportUseCase(this.repository);

  Future<ReportResponse> call(String animalRefId) {
    return repository.getLiveStockReports(animalRefId: animalRefId);
  }
}
