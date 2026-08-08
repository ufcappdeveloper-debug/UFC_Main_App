import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/authentication_repo.dart';

class AutoLoginUsecase {
  final AuthRepository repository;

  AutoLoginUsecase(this.repository);

  Future<UserModel> call() {
    return repository.autoLogin();
  }
}
