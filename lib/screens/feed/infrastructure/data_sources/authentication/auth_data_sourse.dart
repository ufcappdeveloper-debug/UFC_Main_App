import '../../../domain/entities/authentication/user_model.dart';

abstract class AuthDataSource {
  Future<bool> requestOtp(Map<String, String> data);
  Future<UserModel> verifyOtp(Map<String, String> data);
  Future<UserModel> getProfile();
  Future<EditUserResponse> editUser(int id, Map<String, dynamic> data);
  Future<UserModel> autoLogin();
  Future<void> logout();
  Future<void> deleteAccount();
  Future<void> editEmailPhone(Map<String, dynamic> data);
  Future<void> verifyNewEmailPhone(Map<String, dynamic> data);
  Future<UserModel> googleSociaLogin(Map<String, dynamic> data);
  Future<UserModel> twitterSociaLogin(Map<String, dynamic> data);
  Future<UserModel> appleSociaLogin(Map<String, dynamic> data);
  Future<UserModel> loginWithEmail(Map<String, dynamic> data);
  Future<void> registerWithEmail(Map<String, dynamic> data);
  Future<void> resetPasswordEmail(Map<String, dynamic> data);
  Future<void> verifyResetPassword(Map<String, dynamic> data);
  Future<void> updatePassword(Map<String, dynamic> data);
}
