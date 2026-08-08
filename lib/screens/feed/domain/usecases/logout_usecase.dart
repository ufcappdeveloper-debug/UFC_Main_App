import '../repositories/authentication_repo.dart';

class LogoutUsecase {
  final AuthRepository repository;
  LogoutUsecase(this.repository);

  Future<void> call() async {
    return repository.logout();
  }
}
