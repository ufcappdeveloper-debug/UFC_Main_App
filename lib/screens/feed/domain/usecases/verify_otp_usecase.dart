import '../entities/authentication/user_model.dart';
import '../repositories/authentication_repo.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;

  VerifyOtpUsecase(this.repository);

  Future<UserModel> call(Map<String, String> data) {
    return repository.verifyOtp(data);
  }
}
