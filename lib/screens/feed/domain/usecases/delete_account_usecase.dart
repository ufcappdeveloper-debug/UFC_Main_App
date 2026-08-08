import '../repositories/authentication_repo.dart';

class DeleteAccountUsecase {
  final AuthRepository repository;
  DeleteAccountUsecase(this.repository);

  Future<void> call() async {
    return repository.deleteAccount();
  }
}
