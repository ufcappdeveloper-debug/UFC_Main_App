import '../entities/authentication/user_model.dart';
import '../repositories/authentication_repo.dart';

class EditUserUsecase {
  final AuthRepository repository;

  EditUserUsecase(this.repository);

  Future<EditUserResponse> call(int id, Map<String, dynamic> data) {
    return repository.editUser(id, data);
  }
}
