import 'package:equatable/equatable.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';

abstract class SadadUserInfoState extends Equatable {
  const SadadUserInfoState();

  @override
  List<Object?> get props => [];
}

class SadadInitial extends SadadUserInfoState {}

class SadadLoading extends SadadUserInfoState {}

class SadadLoaded extends SadadUserInfoState {
  final SadadUserInfo? userInfo;

  const SadadLoaded(this.userInfo);
}

class SadadError extends SadadUserInfoState {
  final Object message;

  const SadadError(this.message);
}
