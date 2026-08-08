import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/app_settings/app_setting_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/app_setting/app_settings_model.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/app_setting_usecase.dart';

class AppSettingCubit extends Cubit<AppSettingState> {
  final GetAppSettingUseCase getAppSettingUseCase;

  AppSettingCubit(this.getAppSettingUseCase) : super(AppSettingInitial());

  Future<AppSettingsModel?> fetchAppSettings() async {
    try {
      emit(AppSettingLoading());

      final response = await getAppSettingUseCase();
      if (response != null) {
        emit(AppSettingLoaded(response));
        return response;
      }
      return null;
    } catch (e) {
      emit(AppSettingError(e));
      return null;
    }
  }
}
