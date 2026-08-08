import 'package:ufc_mobile/screens/feed/domain/repositories/authentication_repo.dart';

class UpdatePasswordUsecase {
  final AuthRepository repository;
  UpdatePasswordUsecase(this.repository);

  Future<void> call(Map<String, dynamic> data) async {
    return repository.updatePassword(data);
  }
}