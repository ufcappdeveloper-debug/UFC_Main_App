import 'package:ufc_mobile/screens/feed/domain/repositories/authentication_repo.dart';

class EditEmailPhoneUsecase {
  final AuthRepository repository;
  EditEmailPhoneUsecase(this.repository);

  Future<void> call(Map<String, dynamic> data) async {
    return repository.editEmailPhone(data);
  }
}
