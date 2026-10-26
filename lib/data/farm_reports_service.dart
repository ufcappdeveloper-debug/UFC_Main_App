import 'dart:developer';

import 'package:dio/dio.dart';

import '../global/shared/constants/constants.dart';
import '../screens/farm/domain/entities/barn/livestock.dart';
import '../screens/farm/domain/entities/report_category.dart';

export '../global/config/farm_dio.dart';
import '../global/config/farm_dio.dart';


class FarmReportsService {
  Future<List<ReportCategory>> getReportCategories() async {
    Response response =
        await FarmDio.api.get("/api/ufc-farm/v1/user/report-categories");
    return (response.data["data"] as List<dynamic>)
        .map((data) => ReportCategory.fromJson(data))
        .toList();
  }

  /// With [animalKey] the API returns only that animal's options (no
  /// "type - " prefixes), or an `unavailable_reason` when the report doesn't
  /// apply to it (e.g. productive status for a male).
  Future<({List<ReportQuestion> questions, String? unavailableReason})>
      getQuestions(int id, {String? animalKey}) async {
    Response response = await FarmDio.api.get(
        "/api/ufc-farm/v1/user/report-categories/$id/questions",
        queryParameters: {
          "limit": 100,
          "is_active": 1,
          "is_follow_up": 0,
          if (animalKey != null && animalKey.isNotEmpty)
            "animal_unique_key": animalKey,
        });
    final reason = response.data is Map
        ? response.data["unavailable_reason"]?.toString()
        : null;
    return (
      questions: ((response.data["data"] as List<dynamic>?) ?? [])
          .map((data) => ReportQuestion.fromJson(data))
          .toList(),
      unavailableReason: (reason?.isEmpty ?? true) ? null : reason,
    );
  }

  Future<ReportQuestionContent> addContents(
      {required int categoryId,
      required int questionId,
      required String text}) async {
    Response response = await FarmDio.api.post(
        "/api/ufc-farm/v1/user/report-categories/$categoryId/questions/$questionId/contents",
        data: {"content": text});
    return ReportQuestionContent.fromJson(response.data["data"]);
  }

  Future<ReportQuestion> getContents(
      {required int categoryId,
      required int questionId,
      String? animalKey}) async {
    Response response = await FarmDio.api.get(
        "/api/ufc-farm/v1/user/report-categories/$categoryId/questions/$questionId/contents",
        queryParameters: {
          if (animalKey != null && animalKey.isNotEmpty)
            "animal_unique_key": animalKey,
        });
    return ReportQuestion.fromJson(response.data["data"]);
  }

  Future<void> addAnswers(int reportId, List<Map<String, dynamic>> data) async {
    log('datadatadatadatadata: $data');
    await FarmDio.api.post(
        "/api/ufc-farm/v1/user/report-categories/$reportId/answers",
        data: {"answers": data});
  }

  Future<AnimalData> getLivestocks({String? category, int? barnId}) async {
    final queryParams = <String, dynamic>{};

    if (category != null) {
      queryParams["animal_category"] = category;
    }
    if (barnId != null) {
      queryParams["barn_id"] = barnId;
    }
    queryParams["lang"] = isArabic
        ? 'ar'
        : isUrdu
            ? 'ur'
            : 'en';
    Response response = await FarmDio.api.get(
      "/api/ufc-farm/v1/user/animals-filter",
      queryParameters: queryParams,
    );
    return AnimalData.fromJson(response.data["data"]);
  }

  Future<String?> getAnimalKey() async {
    Response response =
        await FarmDio.api.get('/api/ufc-farm/v1/user/random-animal-key');
    return response.data['data'];
  }

  Future<void> addDeath(Map<String, dynamic> param) async {
    await FarmDio.api.post("/api/ufc-farm/v1/user/deaths/", data: param);
  }
}
// 98j21l342b2wrx7z
// hdlwmrs3kqbvrufy
// y0bnsodhid3fu0yi
//2rvzi4q633nzyp58
