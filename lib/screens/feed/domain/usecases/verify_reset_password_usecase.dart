import 'package:ufc_mobile/screens/feed/domain/repositories/authentication_repo.dart';

class VerifyResetPasswordUsecase {
  final AuthRepository repository;
  VerifyResetPasswordUsecase(this.repository);

  Future<void> call(Map<String, dynamic> data) async {
    return repository.verifyResetPassword(data);
  }
}
