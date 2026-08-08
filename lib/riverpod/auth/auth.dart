import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/data/auth_service.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_phone_model.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';
import 'package:ufc_mobile/global/util/storage/app_storage.dart';

part "auth.g.dart";

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  FutureOr<UserModel?> build() async {
    return null;
  }

  bool isAuthorized() => state.hasValue && state.value != null;

  /* < ---- Register, Login, Guest, Logout & Delete ---- > */

  // Register With Email
  Future<void> registerWithEmail(final data) async {
    try {
      await AuthService().registerWithEmail(data);
    } on DioException catch (e) {
      debugLog("Error: ${e.dioMessage}");
      throw e.dioMessage;
    } catch (e) {
      debugLog("Error: $e");
      throw e.toString();
    }
  }

  // Login with Phone Number: Request Otp
  Future<void> requestOtp(final data) async {
    try {
      await AuthService().requestOtp(data);
    } on DioException catch (e) {
      debugLog("Error: ${e.dioMessage}");
      throw e.dioMessage;
    } catch (e) {
      debugLog("Error: $e");
      throw e.toString();
    }
  }

  // Login with Phone Number: Verify Otp
  Future<void> verifyOtp(
      {required String otp,
      required String countryCode,
      required String phoneNumber}) async {
    try {
      state = AsyncValue.data(await AuthService().verifyOtp({
        "otp": otp,
        "country_code": countryCode,
        "phone_number": phoneNumber,
      }));
    } on DioException catch (e) {
      debugLog("Error: ${e.dioMessage}");
      throw e.dioMessage;
    } catch (e) {
      debugLog("Error: $e");
      throw e.toString();
    }
  }

  // Login With Email
  Future<void> loginWithEmail(final data) async {
    try {
      state = AsyncValue.data(await AuthService().loginWithEmail(data));
    } on DioException catch (e) {
      debugLog("Error: ${e.dioMessage}");
      throw e.dioMessage;
    } catch (e) {
      debugLog("Error: $e");
      throw e.toString();
    }
  }

  // Social Login: Google
  Future<void> googleSociaLogin(final data) async {
    try {
      state = AsyncValue.data(await AuthService().googleSociaLogin(data));
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Social Login: Apple
  Future<void> appleSociaLogin(final data) async {
    try {
      state = AsyncValue.data(await AuthService().appleSociaLogin(data));
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Social Login: Twitter
  Future<void> twitterSociaLogin(final data) async {
    try {
      state = AsyncValue.data(await AuthService().twitterSociaLogin(data));
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Login With Firebase
  Future<void> login(final data) async {
    try {
      final userModel = await AuthService().login(data);
      state = AsyncValue.data(userModel);
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Auto Login
  Future<bool> autoLogin() async {
    if (AppConfig.token == null) return false;
    try {
      final userModel = await AuthService().autoLogin();
      state = AsyncValue.data(userModel);
      return true;
    } on DioException catch (_) {
      await AppStorage.removeToken;
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // Guest
  Future<void> guestLogin() async {
    try {
      await AppStorage.removeToken;
      state = AsyncValue.data(null);
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  // Log Out
  Future<void> logout() async {
    try {
      await AppStorage.removeToken;
      await AuthService().logout();
    } catch (e) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  // Delete User
  Future<void> deleteUser() async {
    try {
      await AuthService().deleteUser();
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  /* < ---- Edit User Details ---- > */

  // Edit User Details: Exclude User Email or Phone Number
  Future<void> editUser(final int userId, final data) async {
    try {
      state = AsyncValue.data(await AuthService().editUser(userId, data));
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Edit User Details: Request OTP for User Email or Phone Number Modification
  Future<void> editEmailPhone(final data) async {
    try {
      await AuthService().editEmailPhone(data);
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Edit User Details: Verify Otp for User Email or Phone Number Modification
  Future<void> verifyNewEmailPhone(final data) async {
    try {
      await AuthService().verifyNewEmailPhone(data);
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // Edit User Details: User Phone Number Modification
  Future<void> updatePhoneNumber(final newNumber) async {
    state.value?.phone = UserPhoneModel(
        alphaCode: 'SA', countryCode: '+966', phoneNumber: newNumber);
    state = AsyncValue.data(state.value);
  }

  // Edit User Details: Request OTP for Forgot Password
  Future<void> resetUserPasswordEmail(final data) async {
    try {
      await AuthService().resetUserPasswordEmail(data);
    } on DioException catch (e) {
      debugLog("Error: ${e.dioMessage}");
      throw e.dioMessage;
    } catch (e) {
      debugLog("Error: $e");
      throw e.toString();
    }
  }

  // Edit User Details: Verify Otp for Forgot Password
  Future<void> verifyResetUserPasswordEmail(final data) async {
    try {
      await AuthService().verifyResetUserPasswordEmail(data);
    } on DioException catch (e) {
      debugLog("Error: ${e.dioMessage}");
      throw e.dioMessage;
    } catch (e) {
      debugLog("Error: $e");
      throw e.toString();
    }
  }

  // Edit User Details: Update User News Letter
  Future<void> updateNewsLetter(bool newsLetterEnabled) async {
    final userModel = state.value!;
    userModel.newsletter = newsLetterEnabled;
    state = AsyncValue.data(userModel);
  }

  // Edit User Details: Update User Preferred Shop
  Future<bool> updatePreferredShop(String shopId) async {
    try {
      final userModel = await AuthService().updatePreferredShop(shopId);
      // state.value?.preferredShop = userModel.preferredShop;
      // state.value?.preferredShopDetails = userModel.preferredShopDetails;
      state = AsyncValue.data(userModel);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // Edit User Details: Update User Favorite Shop List
  Future<void> updateFavoriteShop(bool liked, int productId) async {
    if (liked) {
      state.value?.favoriteProducts?.add(productId);
    } else {
      state.value?.favoriteProducts!
          .removeWhere((element) => element == productId);
    }
    state = AsyncValue.data(state.value);
  }

  // Edit User Details: Update User Email Password
  Future<void> updateUserPassword(final data) async {
    try {
      state = AsyncValue.data(await AuthService().updateUserPassword(data));
    } on DioException catch (e) {
      throw json.decode(e.dioMessage)["message"];
    } catch (e) {
      throw json.decode(e.toString())["message"];
    }
  }

  // Edit User Details: Update User Wallet Amount
  Future<void> updateWalletAmount(final walletAmount) async {
    final userModel = state.value!;
    final currentWalletAmount = userModel.walletAmount ?? 0;
    final updatedWalletAmount = currentWalletAmount + walletAmount;
    userModel.walletAmount = updatedWalletAmount;
    state = AsyncValue.data(userModel);
  }

  // Edit User Details: Update User Preferences
  Future<void> updatePreferences(UserModel updatedPreferenceModel) async {
    final userModel = state.value!;
    userModel.pushNotifAll = updatedPreferenceModel.pushNotifAll;
    userModel.pushNotifAccountOrders =
        updatedPreferenceModel.pushNotifAccountOrders;
    userModel.pushNotifOffersPromotion =
        updatedPreferenceModel.pushNotifOffersPromotion;
    userModel.emailNotifAll = updatedPreferenceModel.emailNotifAll;
    userModel.emailNotifOfferProducts =
        updatedPreferenceModel.emailNotifOfferProducts;
    userModel.smsNotifAccountOrders =
        updatedPreferenceModel.smsNotifAccountOrders;
    state = AsyncValue.data(userModel);
  }

  // Just for now, updating userData regarding the progress of AuthCubit
  Future<void> updateUserFromCubit(UserModel user) async {
    try {
      state = AsyncValue.data(user);
    } catch (e) {
      debugLog("Error: $e");
      throw e.toString();
    }
  }
}
