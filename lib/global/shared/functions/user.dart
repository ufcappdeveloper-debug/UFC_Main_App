import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';

bool isUserNameExist(UserModel? user) {
  if (user == null ||
      user.name == null ||
      user.name!.isEmpty ||
      user.lastName == null ||
      user.lastName!.isEmpty) {
    return false;
  }
  return true;
}
