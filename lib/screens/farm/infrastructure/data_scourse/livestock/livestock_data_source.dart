import 'package:ufc_mobile/screens/farm/domain/entities/livestock/live_stock_details_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/livestock_reports_model.dart';

import '../../../domain/entities/barn/livestock.dart';
import '../../../domain/entities/report_category.dart';

abstract class LiveStockDetailsDataSource {
  Future<LiveStockDetailsResponse> getLiveStockDetails(String animalRedId);
  Future<AnimalData> getLivestocks({String? category});
  Future<ReportResponse> getLiveStockReports({String? animalRefId});
  Future<void> deleteLiveStock(String animalKey);
  Future<ReportQuestion> getQuestion(int reportId, int questionId);
  Future<void> editAnswer(Map<String, dynamic> param, int answerId);
  Future<void> deleteAnswer(int answerId);
  Future<void> updateVaccine(Map<String, dynamic> param);
  Future<void> deleteVaccine(int id);
  Future<void> deleteDeath(int deathId);
  Future<void> updateDeath(Map<String, dynamic> param, int id);
}
