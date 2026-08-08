import 'package:ufc_mobile/screens/farm/domain/repositories/livestock_repo.dart';

import '../entities/report_category.dart';

class GetQuestionUsecase {
  final LiveStockRepository repository;

  GetQuestionUsecase(this.repository);

  Future<ReportQuestion> call(int reportId, int questionId) {
    return repository.getQuestion(reportId, questionId);
  }
}
