import 'package:dio/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';

import '../../../../global/shared/functions/dio.dart';
import '../../domain/failure/failure.dart';
import '../../domain/repositories/authentication_repo.dart';
import '../data_sources/authentication/auth_data_sourse.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthDataSource authDataSourse;
  AuthRepoImpl(this.authDataSourse);

  @override
  Future<bool> requestOtp(Map<String, String> data) async {
    try {
      final result = await authDataSourse.requestOtp(data);
      return result;
    } on DioException catch (e) {
      throw NetworkFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authDataSourse.logout();
    } on DioException catch (e) {
      throw NetworkFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await authDataSourse.deleteAccount();
    } on DioException catch (e) {
      throw NetworkFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<EditUserResponse> editUser(int id, Map<String, dynamic> data) async {
    try {
      return await authDataSourse.editUser(id, data);
    } on DioException catch (e) {
      throw NetworkFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final result = await authDataSourse.getProfile();
      return result;
    } on DioException catch (e) {
      throw NetworkFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<UserModel> verifyOtp(Map<String, String> data) async {
    try {
      final result = await authDataSourse.verifyOtp(data);
      return result;
    } on DioException catch (e) {
      throw NetworkFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<UserModel> autoLogin() async {
    try {
      return await authDataSourse.autoLogin();
    } on DioException catch (e) {
      throw NetworkFailure(extractErrorMessage(e.response?.data));
    } catch (e) {
      throw UnexpectedFailure("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<void> editEmailPhone(Map<String, dynamic> data) {
    try {
      return authDataSourse.editEmailPhone(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyNewEmailPhone(Map<String, dynamic> data) {
    try {
      return authDataSourse.verifyNewEmailPhone(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPasswordEmail(Map<String, dynamic> data) {
    try {
      return authDataSourse.resetPasswordEmail(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyResetPassword(Map<String, dynamic> data) {
    try {
      return authDataSourse.verifyResetPassword(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> googleSociaLogin(Map<String, dynamic> data) {
    try {
      return authDataSourse.googleSociaLogin(data);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<UserModel> twitterSociaLogin(Map<String, dynamic> data) {
   try {
      return authDataSourse.twitterSociaLogin(data);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<UserModel> appleSociaLogin(Map<String, dynamic> data) {
     try {
      return authDataSourse.appleSociaLogin(data);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<UserModel> loginWithEmail(Map<String, dynamic> data) {
    try {
      return authDataSourse.loginWithEmail(data);
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<void> registerWithEmail(Map<String, dynamic> data) {
    try {
      return authDataSourse.registerWithEmail(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePassword(Map<String, dynamic> data) {
    try {
      return authDataSourse.updatePassword(data);
    } catch (e) {
      rethrow;
    }
  }
}
