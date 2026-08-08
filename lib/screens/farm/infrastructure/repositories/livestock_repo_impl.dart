import 'package:ufc_mobile/screens/farm/domain/entities/barn/livestock.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/live_stock_details_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/livestock_reports_model.dart';
import 'package:ufc_mobile/screens/farm/domain/repositories/livestock_repo.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/livestock/livestock_data_source.dart';

import '../../domain/entities/report_category.dart';

class LivestockRepoImpl implements LiveStockRepository {
  final LiveStockDetailsDataSource liveStockDetailsDataSource;
  LivestockRepoImpl(this.liveStockDetailsDataSource);

  @override
  Future<LiveStockDetailsResponse> getLiveStockDetails(
    String animalRefId,
  ) async {
    final liveStockDetails =
        await liveStockDetailsDataSource.getLiveStockDetails(animalRefId);
    return liveStockDetails;
  }

  @override
  Future<AnimalData> getLivestocks({String? category}) async {
    return await liveStockDetailsDataSource.getLivestocks(category: category);
  }

  @override
  Future<ReportResponse> getLiveStockReports({
    String? animalRefId,
  }) async {
    final liveStockReports = await liveStockDetailsDataSource
        .getLiveStockReports(animalRefId: animalRefId);
    return liveStockReports;
  }

  @override
  Future<void> deleteLiveStock(String animalKey) async {
    await liveStockDetailsDataSource.deleteLiveStock(animalKey);
  }

  @override
  Future<ReportQuestion> getQuestion(int reportId, int questionId) async {
    return await liveStockDetailsDataSource.getQuestion(reportId, questionId);
  }

  @override
  Future<void> editAnswer(Map<String, dynamic> param, int answerId) async {
    await liveStockDetailsDataSource.editAnswer(param, answerId);
  }

  @override
  Future<void> deleteAnswer(int answerId) async {
    await liveStockDetailsDataSource.deleteAnswer(answerId);
  }

  @override
  Future<void> updateVaccine(Map<String, dynamic> param) async {
    await liveStockDetailsDataSource.updateVaccine(param);
  }

  @override
  Future<void> deleteVaccine(int id) async {
    await liveStockDetailsDataSource.deleteVaccine(id);
  }

  @override
  Future<void> deleteDeath(int deathId) async {
    await liveStockDetailsDataSource.deleteDeath(deathId);
  }


  @override
  Future<void> updateDeath(Map<String, dynamic> param, int id) async {
    await liveStockDetailsDataSource.updateDeath(param, id);
  }
}
