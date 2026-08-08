
import '../repositories/barn_repo.dart';

class UpdateFeedQuantityUsecase {
  final BarnRepository repository;

  UpdateFeedQuantityUsecase(this.repository);

  Future<void> call(int barnId, int feedQuantity) async {
    await repository.updateFeedQuantity(barnId, feedQuantity);
  }
}
