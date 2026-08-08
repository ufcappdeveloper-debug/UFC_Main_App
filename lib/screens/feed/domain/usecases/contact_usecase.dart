
import '../entities/contact/support_model.dart';
import '../repositories/contact_repo.dart';

class CreateSupportUseCase {
  final SupportRepository repository;

  CreateSupportUseCase(this.repository);

  Future<String> call(SupportRequest request) {
    return repository.createSupport(request);
  }
}
