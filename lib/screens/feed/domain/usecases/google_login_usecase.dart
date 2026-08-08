import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/authentication_repo.dart';

class GoogleLoginUsecase {
  final AuthRepository repository;

  GoogleLoginUsecase(this.repository);

  Future<UserModel> call(Map<String, dynamic> data) {
    return repository.googleSociaLogin(data);
  }
}
