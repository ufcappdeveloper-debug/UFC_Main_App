part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

// Profile edit success
final class ProfileEditSuccess extends AuthState {
  final UserModel user;
  final String message;

  const ProfileEditSuccess(this.user,
      {this.message = "Profile updated successfully"});

  @override
  List<Object?> get props => [user, message];
}

final class EditEmailPhoneSuccess extends AuthState {
  final UserModel user;
  final String message;

  const EditEmailPhoneSuccess(this.user,
      {this.message = "Profile updated successfully"});

  @override
  List<Object?> get props => [user, message];
}
final class EditEmailPhoneFailure extends AuthState {
  final Object message;

  const EditEmailPhoneFailure(this.message);

  @override
  List<Object?> get props => [message];
}


final class ProfileEditLoading extends AuthState {
  const ProfileEditLoading();
}

// Profile edit failure
final class ProfileEditFailure extends AuthState {
  final Object message;

  const ProfileEditFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {
  final bool isResend;
  final bool isGoogle;
  final bool isTwitter;
  const AuthLoading({
    this.isResend = false,
    this.isGoogle = false,
    this.isTwitter = false,
  });
}

class PreferredShopUpdated extends AuthState {
  final String message;
  const PreferredShopUpdated(this.message);

  @override
  List<Object> get props => [message];
}

final class ProfileLoadedSuccess extends AuthState {
  final UserModel user;
  const ProfileLoadedSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class PreferredShopUpdateSuccess extends AuthState {
  final UserModel user;
  final String message;

  const PreferredShopUpdateSuccess(this.user, this.message);

  @override
  List<Object> get props => [user, message];
}

final class OtpSentSuccess extends AuthState {
  final bool isResend;
  const OtpSentSuccess({this.isResend = false});
}

final class OtpVerifiedSuccess extends AuthState {
  final UserModel user;
  const OtpVerifiedSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

final class AuthError extends AuthState {
  final Object message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

final class RegisterSuccess extends AuthState {
  final String message;

  const RegisterSuccess([this.message = "Account Created successfully"]);

  @override
  List<Object?> get props => [message];
}

final class GuestLoginLoading extends AuthState {
  const GuestLoginLoading();
}

final class GuestLoginSuccess extends AuthState {
  const GuestLoginSuccess();
}

class ResetPasswordSuccess extends AuthState {}

class UpdatePasswordSuccess extends AuthState {}
class UpdatePasswordLoading extends AuthState {}
final class UpdatePasswordError extends AuthState {
  final String message;
  const UpdatePasswordError(this.message);
  @override
  List<Object?> get props => [message];
}
