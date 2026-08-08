import '../entities/barn/animal_model.dart';
import '../entities/dashboard/dashboard_card_model.dart';
import '../entities/donut_chart_model.dart';

abstract class DeathRepository {
  Future<List<AnimalModel>> getDeath(Map<String, dynamic> param);
  Future<DonutChartModel> getDeathDonutChart(String? category);
  Future<CardModel> getDeathLineChart(String? category);
}
