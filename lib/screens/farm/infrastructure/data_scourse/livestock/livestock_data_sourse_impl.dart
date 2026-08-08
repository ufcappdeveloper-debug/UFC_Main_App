import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ufc_mobile/data/barn_service.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/live_stock_details_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/livestock/livestock_reports_model.dart';
import 'package:ufc_mobile/screens/farm/infrastructure/data_scourse/livestock/livestock_data_source.dart';

import '../../../../../global/shared/functions/dio.dart';
import '../../../../feed/domain/failure/failure.dart';
import '../../../domain/entities/barn/livestock.dart';
import '../../../domain/entities/report_category.dart';

class LiveStockDetailsDataSourceImpl implements LiveStockDetailsDataSource {
  LiveStockDetailsDataSourceImpl();

  @override
  Future<LiveStockDetailsResponse> getLiveStockDetails(
      String animalRedId) async {
    try {
      final response = await FarmDio.api
          .get('/api/ufc-farm/v1/user/animals/$animalRedId/details');

      if (response.statusCode == 200) {
        return LiveStockDetailsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load livestock details');
      }
    } on DioException catch (e) {
      // Convert DioError to your custom Failure or simply throw
      throw Exception(e.error);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<AnimalData> getLivestocks({String? category}) async {
    try {
      Response response = await FarmDio.api.get(category != null
          ? "/api/ufc-farm/v1/user/animals-filter?animal_category=$category"
          : "/api/ufc-farm/v1/user/animals-filter");
      return AnimalData.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(e.error);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ReportResponse> getLiveStockReports({String? animalRefId}) async {
    try {
      final response = await FarmDio.api.get(
          '/api/ufc-farm/v2/user/animals/$animalRefId/report-answers?language=${isArabic ? 'ar' : isEnglish ? 'en' : isUrdu ? 'ur' : 'en'}');

      if (response.statusCode == 200) {
        return ReportResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load livestock details');
      }
    } on DioException catch (e) {
      // Convert DioError to your custom Failure or simply throw
      throw Exception(e.error);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteLiveStock(String animalKey) async {
    try {
      await FarmDio.api.delete('/api/ufc-farm/v1/user/animals/$animalKey');
    } on DioException catch (e) {
      throw UnexpectedFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ReportQuestion> getQuestion(int reportId, int questionId) async {
    try {
      final response = await FarmDio.api.get(
          '/api/ufc-farm/v1/user/report-categories/$reportId/questions/$questionId/contents');
      return ReportQuestion.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw UnexpectedFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> editAnswer(Map<String, dynamic> param, int answerId) async {
    try {
      log('reportParams: $param');
      final response = await FarmDio.api.post(
          '/api/ufc-farm/v1/user/report-answers/$answerId/edit',
          data: param);
      log('responseresponseresponse: $response');
    } on DioException catch (e) {
      throw UnexpectedFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteAnswer(int answerId) async {
    try {
      await FarmDio.api
          .delete('/api/ufc-farm/v1/user/report-answers/$answerId');
    } on DioException catch (e) {
      throw UnexpectedFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> updateVaccine(Map<String, dynamic> param) async {
    try {
      final response = await FarmDio.api
          .post('/api/ufc-farm/v1/user/vaccine/edit', data: param);
      log('responseresponseresponse: $response');
    } on DioException catch (e) {
      throw UnexpectedFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteVaccine(int id) async {
    try {
      await FarmDio.api.delete('/api/ufc-farm/v1/user/vaccine/$id');
    } on DioException catch (e) {
      throw UnexpectedFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteDeath(int deathId) async {
    try {
      await FarmDio.api.delete('/api/ufc-farm/v1/user/deaths/$deathId');
    } on DioException catch (e) {
      throw UnexpectedFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }


  @override
  Future<void> updateDeath(Map<String, dynamic> param, int id) async {
    try {
      final response = await FarmDio.api
          .post('/api/ufc-farm/v1/user/deaths/$id/edit', data: param);
      log('responseresponseresponse: $response');
    } on DioException catch (e) {
      throw UnexpectedFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

}
