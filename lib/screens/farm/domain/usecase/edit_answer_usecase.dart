import '../repositories/livestock_repo.dart';

class EditAnswerUsecase {
  final LiveStockRepository repository;

  EditAnswerUsecase(this.repository);

  Future<void> call(Map<String, dynamic> param, int reportId) async {
    await repository.editAnswer(param, reportId);
  }
}
