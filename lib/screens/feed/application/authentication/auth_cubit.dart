import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/util/storage/app_storage.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_phone_model.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/apple_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/auto_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/edit_email_phone_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/email_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/google_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/register_email_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/reset_password_email_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/twitter_login_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/update_password.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/verify_new_email_phone_usecase.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/verify_reset_password_usecase.dart';

import '../../domain/entities/authentication/user_model.dart';
import '../../domain/entities/station/station_model.dart';
import '../../domain/failure/failure.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/edit_user_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/request_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RequestOtpUsecase requestOtpUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final GetProfileUsecase getProfileUsecase;
  final EditUserUsecase editUserUsecase;
  final AutoLoginUsecase autoLoginUseCase;
  final LogoutUsecase logoutUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;
  final EditEmailPhoneUsecase editEmailPhoneUsecase;
  final ResetPasswordEmailUsecase resetPasswordEmailUsecase;
  final VerifyResetPasswordUsecase verifyResetPasswordUsecase;
  final VerifyNewEmailPhoneUsecase verifyNewEmailPhoneUsecase;
  final GoogleLoginUsecase googleLoginUseCase;
  final TwitterLoginUsecase twitterLoginUseCase;
  final AppleLoginUsecase appleLoginUseCase;
  final EmailLoginUsecase emailLoginUseCase;
  final RegisterEmailUsecase registerEmailUsecase;
  final UpdatePasswordUsecase updatePasswordUsecase;
  UserModel? currentUser;
  bool _isGuest = false;
  AuthCubit(
      this.requestOtpUsecase,
      this.verifyOtpUsecase,
      this.getProfileUsecase,
      this.editUserUsecase,
      this.autoLoginUseCase,
      this.logoutUsecase,
      this.deleteAccountUsecase,
      this.editEmailPhoneUsecase,
      this.resetPasswordEmailUsecase,
      this.verifyResetPasswordUsecase,
      this.verifyNewEmailPhoneUsecase,
      this.googleLoginUseCase,
      this.twitterLoginUseCase,
      this.appleLoginUseCase,
      this.emailLoginUseCase,
      this.registerEmailUsecase,
      this.updatePasswordUsecase)
      : super(AuthInitial());

  bool get isGuest => _isGuest;

  Future<void> autoLogin() async {
    emit(AuthLoading());
    try {
      final updatedUser = await autoLoginUseCase();
      currentUser = updatedUser;
      emit(ProfileLoadedSuccess(updatedUser));
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> editUser(int id, Map<String, dynamic> data) async {
    emit(
        const ProfileEditLoading()); // ✅ specific loading state for profile edit
    try {
      final result =
          await editUserUsecase(id, data); // returns EditUserResponse
      currentUser = result.user;
      emit(ProfileEditSuccess(result.user, message: result.message));
    } on Failure catch (f) {
      emit(ProfileEditFailure(f.message));
    } catch (e) {
      emit(ProfileEditFailure(e.toString()));
    }
  }

  Future<void> requestOtp(
    Map<String, String> data, {
    bool isResend = false,
  }) async {
    emit(AuthLoading(isResend: isResend, isGoogle: false, isTwitter: false));
    try {
      final success = await requestOtpUsecase(data);
      if (success) {
        emit(OtpSentSuccess(isResend: isResend));
      } else {
        emit(AuthError("Failed to send OTP"));
      }
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await logoutUsecase();
      currentUser = null;

      emit(AuthInitial());
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError("Logout failed: $e"));
    }
  }

  Future<void> deleteAccount() async {
    emit(AuthLoading());
    try {
      await deleteAccountUsecase();
      currentUser = null;
      emit(AuthInitial());
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError("Delete account failed: $e"));
    }
  }

  Future<void> loadProfile() async {
    emit(AuthLoading());
    try {
      final user = await getProfileUsecase();
      currentUser = user;
      emit(ProfileLoadedSuccess(user));
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError(e));
    }
  }

  Future<void> verifyOtp(Map<String, String> data) async {
    emit(AuthLoading());
    try {
      final user = await verifyOtpUsecase(data);
      currentUser = user;
      _isGuest = false;
      emit(OtpVerifiedSuccess(user));
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError(e));
    }
  }

  void updatePreferredShopInUser(StationModel newStation) {
    debugPrint("📢 updatePreferredShopInUser called");
    debugPrint("CurrentUser before update: $currentUser");

    if (currentUser != null) {
      currentUser = currentUser!.copyWith(
        preferredShop: newStation.id,
        preferredShopDetails: newStation,
      );

      emit(OtpVerifiedSuccess(currentUser!));

      debugPrint("🔄 Updated Current User:");
      debugPrint("ID: ${currentUser!.id}");
      debugPrint("Preferred Shop ID: ${currentUser!.preferredShop}");
      debugPrint(
          "Preferred Shop Name: ${currentUser!.preferredShopDetails?.nameEn}");
    } else {
      debugPrint("❌ currentUser is NULL, cannot update!");
    }
  }

  Future<void> resetUserPasswordEmail(Map<String, String> data) async {
    emit(AuthLoading());
    try {
      await resetPasswordEmailUsecase(data);
      emit(ProfileEditSuccess(currentUser!, message: "success"));
    } on DioException catch (e) {
      emit(ProfileEditFailure(e.error.toString()));
    } catch (e) {
      emit(ProfileEditFailure(e.toString()));
    }
  }

  Future<void> verifyResetUserPassword(Map<String, String> data) async {
    emit(AuthLoading());
    try {
      await verifyResetPasswordUsecase(data);
      emit(ResetPasswordSuccess());
    } on DioException catch (e) {
      emit(ProfileEditFailure(e.error.toString()));
    } catch (e) {
      emit(ProfileEditFailure(e.toString()));
    }
  }

  Future<void> editEmailPhone(Map<String, String> data) async {
    emit(AuthLoading());
    try {
      await editEmailPhoneUsecase(data);
      emit(EditEmailPhoneSuccess(currentUser!,
          message: "OTP sent successfully"));
    } on DioException catch (e) {
      emit(EditEmailPhoneFailure(e.error.toString()));
    } catch (e) {
      emit(EditEmailPhoneFailure(e.toString()));
    }
  }

  Future<void> verifyNewEmailPhone(Map<String, String> data) async {
    emit(AuthLoading());
    try {
      await verifyNewEmailPhoneUsecase(data);
      emit(EditEmailPhoneSuccess(currentUser!,
          message: "Profile updated successfully"));
    } catch (e) {
      emit(EditEmailPhoneFailure(e.toString()));
    }
  }

  Future<void> updatePhoneNumber(String newNumber) async {
    if (currentUser == null) return;
    try {
      // Update the phone in the user model
      final updatedUser = currentUser!.copyWith(
        phone: UserPhoneModel(
          alphaCode: 'SA',
          countryCode: '+966',
          phoneNumber: newNumber,
        ),
      );

      currentUser = updatedUser;

      emit(ProfileEditSuccess(updatedUser));
    } catch (e) {
      emit(ProfileEditFailure(e));
    }
  }

  Future<void> googleSociaLogin(Map<String, String> data) async {
    emit(AuthLoading(isGoogle: true));
    try {
      final user = await googleLoginUseCase(data);
      currentUser = user;
      _isGuest = false;
      emit(ProfileLoadedSuccess(user));
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError(e));
    }
  }

  Future<void> twitterSociaLogin(Map<String, dynamic> data) async {
    emit(AuthLoading(isTwitter: true));
    try {
      final user = await twitterLoginUseCase(data);
      currentUser = user;
      _isGuest = false;
      emit(ProfileLoadedSuccess(user));
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError(e));
    }
  }

  Future<void> appleSociaLogin(Map<String, String> data) async {
    emit(AuthLoading(isGoogle: true));
    try {
      final user = await appleLoginUseCase(data);
      currentUser = user;
      _isGuest = false;
      emit(ProfileLoadedSuccess(user));
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError(e));
    }
  }

  Future<void> loginWithEmail(Map<String, String> data) async {
    emit(AuthLoading(isGoogle: true));
    try {
      final user = await emailLoginUseCase(data);
      currentUser = user;
      _isGuest = false;
      emit(ProfileLoadedSuccess(user));
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError(e));
    }
  }

  Future<void> registerWithEmail(Map<String, dynamic> data) async {
    emit(AuthLoading());
    try {
      await registerEmailUsecase(data);
      emit(RegisterSuccess());
    } on Failure catch (f) {
      emit(AuthError(f.message));
    } catch (e) {
      emit(AuthError(e));
    }
  }

  Future<void> guestLogin() async {
    emit(const GuestLoginLoading());
    try {
      await AppStorage.removeToken;
      _isGuest = true;
      emit(const GuestLoginSuccess());
    } catch (e) {
      emit(AuthError("Guest login failed"));
    }
  }

  Future<void> updatePassword(Map<String, String> data) async {
    emit(UpdatePasswordLoading());
    try {
      await updatePasswordUsecase(data);
      emit(UpdatePasswordSuccess());
    } on Failure catch (f) {
      emit(UpdatePasswordError(f.message.tr())); // translate Failure message
    } catch (e) {
      if (e is DioException) {
        final serverMessage =
            (e.response?.data['message'] ?? 'Something went wrong')
                .toString()
                .tr();
        emit(UpdatePasswordError(serverMessage));
      } else {
        emit(UpdatePasswordError('Something went wrong'.tr()));
      }
    }
  }

// Future<void> updatePreferredShop(String shopId) async {
//     emit(AuthLoading());
//     try {
//       await updatePreferredShopUseCase(shopId);
//
//       if (_currentUser != null) {
//         _currentUser = _currentUser!.copyWith(
//           preferredShopDetails: _currentUser!.preferredShopDetails?.copyWith(
//             id: int.tryParse(shopId),
//           ),
//         );
//
//         emit(PreferredShopUpdateSuccess(
//           _currentUser!,
//           "Preferred shop updated successfully",
//         ));
//       }
//     } catch (e) {
//       emit(AuthError("Unexpected error: $e"));
//     }
//   }
}
