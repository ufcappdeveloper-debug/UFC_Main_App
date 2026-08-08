import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/authentication/auth_data_sourse.dart';

import '../../../../../global/config/config.dart';
import '../../../../../global/config/dio.dart';
import '../../../domain/entities/authentication/user_model.dart';

class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<bool> requestOtp(Map<String, String> data) async {
    Response response =
        await api.post("api/ufc/v1/login_request_otp", data: data);
    return response.data["message"] == "OTP sent successfully" ||
        response.data["status"] == "success";
  }

  @override
  Future<void> logout() async {
    await api.post(
      "api/ufc/v1/logout",
      options: Options(
        headers: {
          "Authorization": "Bearer ${AppConfig.token}",
        },
      ),
    );
  }

  @override
  Future<void> deleteAccount() async {
    await api.delete(
      "api/ufc/v1/delete_user",
      options: Options(
        headers: {
          "Authorization": "Bearer ${AppConfig.token}",
        },
      ),
    );
  }

  /// ✅ FIXED: Return EditUserResponse instead of UserModel
  @override
  Future<EditUserResponse> editUser(int id, Map<String, dynamic> data) async {
    final formData = FormData();

    // Add text fields
    data.forEach((key, value) {
      if (value is! File) {
        formData.fields.add(MapEntry(key, value?.toString() ?? ''));
      }
    });

    // Add image file if exists
    if (data['profile_image'] != null && data['profile_image'] is File) {
      final file = data['profile_image'] as File;
      formData.files.add(
        MapEntry(
          'profile_picture', // must match backend key
          await MultipartFile.fromFile(
            file.path,
            filename: path.basename(file.path),
          ),
        ),
      );
    }

    final response = await api.post(
      "api/ufc/v1/edit_user/$id",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer ${AppConfig.token}",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    print("✅ Edit User Response: ${response.data}");
    final user = UserModel.fromJson(response.data['user']);
    final message = response.data['message'] ?? 'Profile updated';

    return EditUserResponse(user: user, message: message);
  }

  @override
  Future<UserModel> autoLogin() async {
    final response = await api.get(
      "api/ufc/v1/who_am_i",
      options: Options(
        headers: {
          "Authorization": "Bearer ${AppConfig.token}",
        },
      ),
    );

    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await api.get(
      "api/ufc/v1/who_am_i",
      options: Options(
        headers: {
          "Authorization": "Bearer ${AppConfig.token}",
        },
      ),
    );
    print("📡 getProfile API Response: ${response.data}");
    print("👤 User Data: ${response.data["data"]}");

    return UserModel.fromJson(response.data["data"]);
  }

  @override
  Future<UserModel> verifyOtp(Map<String, String> data) async {
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

  @override
  Future<void> editEmailPhone(Map<String, dynamic> data) async {
    try {
      await api.post(
        "api/ufc/v1/edit_email_phone",
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer ${AppConfig.token}",
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyNewEmailPhone(Map<String, dynamic> data) async {
    await api.post(
      "api/ufc/v1/verify_new_email_phone",
      data: data,
      options: Options(
        headers: {
          "Authorization": "Bearer ${AppConfig.token}",
        },
      ),
    );
  }

  @override
  Future<void> resetPasswordEmail(Map<String, dynamic> data) async {
    await api.post(
      "api/ufc/v1/reset_user_password_email",
      data: data,
    );
  }

  @override
  Future<void> verifyResetPassword(Map<String, dynamic> data) async {
    await api.post(
      "api/ufc/v1/verify_reset_user_password_email",
      data: data,
    );
  }

  @override
  Future<UserModel> googleSociaLogin(Map<String, dynamic> data) async {
    try {
      Response response = await api.post(
        "api/ufc/v1/social/google_login",
        data: data,
      );
      return UserModel.fromJson(response.data["data"]["user"]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> twitterSociaLogin(Map<String, dynamic> data) async {
    try {
      Response response = await api.post(
        "api/ufc/v1/social/twitter_login",
        data: data,
      );
      return UserModel.fromJson(response.data["data"]["user"]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> appleSociaLogin(Map<String, dynamic> data) async {
    try {
      Response response = await api.post(
        "api/ufc/v1/social/apple_login",
        data: data,
      );
      return UserModel.fromJson(response.data["data"]["user"]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> loginWithEmail(Map<String, dynamic> data) async {
    try {
      print("DATAAAA --- $data");
      Response response = await api.post(
        "api/ufc/v1/login_with_email",
        data: data,
      );
      print("DATAAAA --- ${response.data}");
      return UserModel.fromJson(response.data["user"]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> registerWithEmail(Map<String, dynamic> data) async {
    try {
      await api.post(
        "api/ufc/v1/register",
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePassword(Map<String, dynamic> data) async {
    try {
      await api.post(
        "api/ufc/v1/update_user_password",
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }
}
