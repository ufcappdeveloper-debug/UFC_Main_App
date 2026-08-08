import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/dashboard_card_model.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/donut_chart_model.dart';

import '../../domain/entities/barn/animal_model.dart';
import '../../domain/repositories/death_repo.dart';
import '../data_scourse/death/death_data_source.dart';

class DeathRepositoryImpl implements DeathRepository {
  final DeathDataSource deathDataSource;

  DeathRepositoryImpl(this.deathDataSource);

  @override
  Future<List<AnimalModel>> getDeath(Map<String, dynamic> param) async {
    return await deathDataSource.getDeath(param);
  }

  @override
  Future<DonutChartModel> getDeathDonutChart(String? category) async {
    return await deathDataSource.getDeathDonutChart(category);
  }

  @override
  Future<CardModel> getDeathLineChart(String? category) async {
    return await deathDataSource.getDeathLineChart(category);
  }
}
