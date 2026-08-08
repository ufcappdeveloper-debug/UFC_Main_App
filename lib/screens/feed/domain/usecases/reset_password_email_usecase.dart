import 'package:ufc_mobile/screens/feed/domain/repositories/authentication_repo.dart';

class ResetPasswordEmailUsecase {
  final AuthRepository repository;
  ResetPasswordEmailUsecase(this.repository);

  Future<void> call(Map<String, dynamic> data) async {
    return repository.resetPasswordEmail(data);
  }
}
