import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';

class AuthService {
  /* < ---- Register, Login, Logout & Delete ---- > */

  // Register With Email
  Future<void> registerWithEmail(final data) async =>
      await api.post("api/ufc/v1/register", data: data);

  // Login with Phone Number: Request Otp
  Future<void> requestOtp(final data) async =>
      await api.post("api/ufc/v1/login_request_otp", data: data);

  // Login with Phone Number: Verify Otp
  Future<UserModel> verifyOtp(final data) async {
    Response response = await api.post("api/ufc/v1/verify_otp", data: data);
    final user = UserModel.fromJson(response.data["user"]);
    Sentry.configureScope(
      (scope) => scope.setUser(
        SentryUser(
          email: user.email?.email,
          name: user.name,
          data: {
            "phone_number": user.phone?.phoneNumber,
          },
          id: user.id?.toString(),
        ),
      ),
    );
    return user;
  }

  // Login With Email
  Future<UserModel> loginWithEmail(final data) async {
    Response response =
        await api.post("api/ufc/v1/login_with_email", data: data);
    return UserModel.fromJson(response.data["user"]);
  }

  // Social Login: Google
  Future<UserModel> googleSociaLogin(final data) async {
    Response response =
        await api.post("api/ufc/v1/social/google_login", data: data);
    return UserModel.fromJson(response.data["data"]["user"]);
  }

  // Social Login: Apple
  Future<UserModel> appleSociaLogin(final data) async {
    Response response =
        await api.post("api/ufc/v1/social/apple_login", data: data);
    return UserModel.fromJson(response.data["data"]["user"]);
  }

  // Social Login: Twitter
  Future<UserModel> twitterSociaLogin(final data) async {
    Response response =
        await api.post("api/ufc/v1/social/twitter_login", data: data);
    return UserModel.fromJson(response.data["data"]["user"]);
  }

  // Login With Firebase
  Future<UserModel> login(final data) async {
    Response response =
        await api.post("api/ufc/v1/login_with_firebase", data: data);
    return UserModel.fromJson(response.data["user"]);
  }

  // Auto Login
  Future<UserModel> autoLogin() async {
    Response response = await api.get("api/ufc/v1/who_am_i");
    return UserModel.fromJson(response.data["data"]);
  }

  // Log Out
  Future<void> logout() async => await api.post("api/ufc/v1/logout");

  // Delete User
  Future<void> deleteUser() async => await api.delete("api/ufc/v1/delete_user");

  /* < ---- Edit User Details ---- > */
  // Edit User Details: Exclude User Email or Phone Number
  Future<UserModel> editUser(final int userId, final data) async {
    Response response =
        await api.post("api/ufc/v1/edit_user/$userId", data: data);
    return UserModel.fromJson(response.data["user"]);
  }

  // Edit User Details: Request OTP for User Email or Phone Number Modification
  Future<void> editEmailPhone(final data) async =>
      await api.post("api/ufc/v1/edit_email_phone", data: data);

  // Edit User Details: Verify Otp for User Email or Phone Number Modification
  Future<void> verifyNewEmailPhone(final data) async =>
      await api.post("api/ufc/v1/verify_new_email_phone", data: data);

  // Edit User Details: Request OTP for Forgot Password
  Future<void> resetUserPasswordEmail(final data) async =>
      await api.post("api/ufc/v1/reset_user_password_email", data: data);

  // Edit User Details: Verify Otp for Forgot Password
  Future<void> verifyResetUserPasswordEmail(final data) async =>
      await api.post("api/ufc/v1/verify_reset_user_password_email", data: data);

  // Edit User Details: Update User Email Password
  Future<UserModel> updateUserPassword(final data) async {
    Response response =
        await api.post("api/ufc/v1/update_user_password", data: data);
    return UserModel.fromJson(response.data["user"]);
  }

  // Edit User Details: Update User Preferred Shop
  Future<UserModel> updatePreferredShop(String shopId) async {
    Response response = await api
        .post("api/ufc/v1/update_preferred_shop", data: {"shop": shopId});
    return UserModel.fromJson(response.data["user"]);
  }
}
