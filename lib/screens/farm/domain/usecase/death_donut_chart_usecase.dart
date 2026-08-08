import '../entities/donut_chart_model.dart';
import '../repositories/death_repo.dart';

class DeathDonutChartUsecase {
  final DeathRepository repository;

  DeathDonutChartUsecase(this.repository);

  Future<DonutChartModel> call(String? category) {
    return repository.getDeathDonutChart(category);
  }
}
