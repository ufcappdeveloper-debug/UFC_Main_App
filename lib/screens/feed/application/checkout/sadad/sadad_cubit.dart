import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/checkout/sadad/sadad_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/sadad_usecase.dart';

class SadadUserInfoCubit extends Cubit<SadadUserInfoState> {
  final GetSadadUseCase getSadadUseCase;
  final UpdateSadadUserInfoUseCase updateSadadUserInfoUseCase;
  SadadUserInfo? userInfo;

  SadadUserInfoCubit(this.getSadadUseCase, this.updateSadadUserInfoUseCase)
      : super(SadadInitial());

  Future<void> getUserInfo() async {
    emit(SadadLoading());
    try {
      final info = await getSadadUseCase();

      emit(SadadLoaded(info));
    } catch (e) {
      emit(SadadError(e));
    }
  }

  Future<void> updateUserInfo(Map<String, dynamic> data) async {
    emit(SadadLoading());
    try {
      final info = await updateSadadUserInfoUseCase(data);
      userInfo = info;
      emit(SadadLoaded(info));
    } catch (e) {
      emit(SadadError(e));
    }
  }
}
