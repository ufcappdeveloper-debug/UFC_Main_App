import '../entities/authentication/user_model.dart';
import '../repositories/authentication_repo.dart';

class GetProfileUsecase {
  final AuthRepository repository;

  GetProfileUsecase(this.repository);

  Future<UserModel> call() {
    return repository.getProfile();
  }
}
