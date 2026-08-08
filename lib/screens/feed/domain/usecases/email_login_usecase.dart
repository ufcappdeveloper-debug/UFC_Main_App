import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/authentication_repo.dart';

class EmailLoginUsecase {
  final AuthRepository repository;

  EmailLoginUsecase(this.repository);

  Future<UserModel> call(Map<String, dynamic> data) {
    return repository.loginWithEmail(data);
  }
}
