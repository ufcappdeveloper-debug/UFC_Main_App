import 'package:dio/dio.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/animal_model.dart';

import '../../../domain/entities/mothers_and_babies.dart';
import 'mothers_and_babies_data_source.dart';
import 'package:ufc_mobile/data/barn_service.dart';

class MothersAndBabiesDataSourceImpl implements MothersAndBabiesDataSource {
  @override
  Future<List<AnimalModel>> getAnimals(Map<String, dynamic> param) async {
    try {
      Response response = await FarmDio.api
          .get("/api/ufc-farm/v1/user/animals-data", queryParameters: param);
      final List<dynamic> data = response.data["data"]["animals"];
      return data.map((json) => AnimalModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.error);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<MothersBabiesChart> getChart(String? animalCategory) async {
    try {
      Response response = await FarmDio.api.get(
          "/api/ufc-farm/v1/user/charts/double-donut-chart", queryParameters: {
            'chart_type':'mothers_babies',
           if(animalCategory!=null) 'animal_category': animalCategory
          });
      return MothersBabiesChart.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(e.error);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
