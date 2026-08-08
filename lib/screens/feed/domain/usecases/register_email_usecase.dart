import 'package:ufc_mobile/screens/feed/domain/repositories/authentication_repo.dart';

class RegisterEmailUsecase {
  final AuthRepository repository;

  RegisterEmailUsecase(this.repository);

  Future<void> call(Map<String, dynamic> data) {
    return repository.registerWithEmail(data);
  }
}
