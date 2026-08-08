import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/sadad_repo.dart';

class GetSadadUseCase {
  final SadadRepository repository;

  GetSadadUseCase(this.repository);
  Future<SadadUserInfo?> call() async {
    return await repository.getUserInfo();
  }
}

class UpdateSadadUserInfoUseCase {
  final SadadRepository repository;

  UpdateSadadUserInfoUseCase(this.repository);

  Future<SadadUserInfo?> call(Map<String, dynamic> data) async {
    return await repository.updateUserInfo(data);
  }
}
