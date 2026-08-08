import 'package:dio/dio.dart';
import 'package:ufc_mobile/data/barn_service.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_card_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/donut_chart_model.dart';

import '../../../domain/entities/barn/animal_model.dart';
import 'death_data_source.dart';

class DeathDataSourceImpl implements DeathDataSource {
  @override
  Future<List<AnimalModel>> getDeath(Map<String, dynamic> param) async {
    try {
      Response response = await FarmDio.api.get(
          "/api/ufc-farm/v1/user/animals-data?requested_data=deaths",
          queryParameters: param);
      final List<dynamic> data = response.data["data"]["animals"];
      return data.map((json) => AnimalModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<DonutChartModel> getDeathDonutChart(String? category) async {
    try {
      Response response = await FarmDio.api
          .get("/api/ufc-farm/v1/user/charts/donut-chart", queryParameters: {
        'targeted_filter': 'death_animals',
        if (category != null) 'animal_category': category
      });
      return DonutChartModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(e.error);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<CardModel> getDeathLineChart(String? category) async {
    try {
      Response response = await FarmDio.api
          .get("/api/ufc-farm/v1/user/charts/line-chart", queryParameters: {
        'targeted_filter': 'death_animals',
        if (category != null) 'animal_category': category
      });
      return CardModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(e.error);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
