import 'package:ufc_mobile/screens/farm/domain/entities/livestock/live_stock_details_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/livestock_reports_model.dart';

import '../entities/barn/livestock.dart';
import '../entities/report_category.dart';

abstract class LiveStockRepository {
  Future<LiveStockDetailsResponse> getLiveStockDetails(String animalRefId);
  Future<AnimalData> getLivestocks({String? category});
  Future<ReportResponse> getLiveStockReports({String? animalRefId});
  Future<void> deleteLiveStock(String animalKey);
  Future<ReportQuestion> getQuestion(int reportId, int questionId);
  Future<void> editAnswer(Map<String, dynamic> param, int reportId);
  Future<void> deleteAnswer(int answerId);
  Future<void> updateVaccine(Map<String, dynamic> param);
  Future<void> deleteVaccine(int id);
  Future<void> deleteDeath(int vaccineId);
  Future<void> updateDeath(Map<String, dynamic> param, int id);
}
