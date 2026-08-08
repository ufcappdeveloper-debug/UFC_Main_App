import 'package:ufc_mobile/screens/farm/domain/repositories/livestock_repo.dart';
import '../entities/barn/livestock.dart';

class LivestockListByCategoryUseCase {
  final LiveStockRepository repository;

  LivestockListByCategoryUseCase(this.repository);

  Future<AnimalData> call(String? category) {
    return repository.getLivestocks(category: category);
  }
}
