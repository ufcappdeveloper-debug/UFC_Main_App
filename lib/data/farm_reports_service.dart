import 'dart:developer';

import 'package:dio/dio.dart';

import '../global/config/config.dart';
import '../global/shared/constants/constants.dart';
import '../screens/farm/domain/entities/barn/livestock.dart';
import '../screens/farm/domain/entities/report_category.dart';
import '../global/util/dio/dio_intrepters.dart';

class FarmDio {
  static final Dio farmDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.farmBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(AppInterceptor());

  static Dio get api => farmDio;
}

class FarmReportsService {
  Future<List<ReportCategory>> getReportCategories() async {
    Response response =
        await FarmDio.api.get("/api/ufc-farm/v1/user/report-categories");
    return (response.data["data"] as List<dynamic>)
        .map((data) => ReportCategory.fromJson(data))
        .toList();
  }

  Future<List<ReportQuestion>> getQuestions(int id) async {
    Response response = await FarmDio.api.get(
        "/api/ufc-farm/v1/user/report-categories/$id/questions",
        queryParameters: {
          "limit": 100,
          "is_active": 1,
          "is_follow_up": 0,
        });
    return (response.data["data"] as List<dynamic>)
        .map((data) => ReportQuestion.fromJson(data))
        .toList();
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
      {required int categoryId, required int questionId}) async {
    Response response = await FarmDio.api.get(
        "/api/ufc-farm/v1/user/report-categories/$categoryId/questions/$questionId/contents");
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
