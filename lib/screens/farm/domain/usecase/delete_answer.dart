import '../repositories/livestock_repo.dart';

class DeleteAnswer {
  final LiveStockRepository repository;

  DeleteAnswer(this.repository);

  Future<void> call(int answerId) async {
    await repository.deleteAnswer(answerId);
  }
}
