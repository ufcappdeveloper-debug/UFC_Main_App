import 'package:ufc_mobile/screens/feed/domain/repositories/authentication_repo.dart';

class VerifyNewEmailPhoneUsecase {
  final AuthRepository repository;
  VerifyNewEmailPhoneUsecase(this.repository);

  Future<void> call(Map<String, dynamic> data) async {
    return repository.verifyNewEmailPhone(data);
  }
}
