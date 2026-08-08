import '../../../domain/entities/barn/animal_model.dart';
import '../../../domain/entities/dashboard/dashboard_card_model.dart';
import '../../../domain/entities/donut_chart_model.dart';

abstract class DeathDataSource {
  Future<List<AnimalModel>> getDeath(Map<String, dynamic> param);
  Future<DonutChartModel> getDeathDonutChart(String? category);
  Future<CardModel> getDeathLineChart(String? category);
}
