import '../repositories/authentication_repo.dart';

class RequestOtpUsecase {
  final AuthRepository repository;

  RequestOtpUsecase(this.repository);

  Future<bool> call(Map<String, String> data) {
    return repository.requestOtp(data);
  }
}
