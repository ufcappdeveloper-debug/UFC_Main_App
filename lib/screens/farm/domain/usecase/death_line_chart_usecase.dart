import '../entities/dashboard/dashboard_card_model.dart';
import '../repositories/death_repo.dart';

class DeathLineChartUsecase {
  final DeathRepository repository;

  DeathLineChartUsecase(this.repository);

  Future<CardModel> call(String? category) {
    return repository.getDeathLineChart(category);
  }
}
