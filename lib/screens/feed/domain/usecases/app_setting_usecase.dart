import 'package:ufc_mobile/screens/feed/domain/entities/app_setting/app_settings_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/app_setting_repo.dart';

class GetAppSettingUseCase {
  final AppSettingRepository repository;

  GetAppSettingUseCase(this.repository);
  Future<AppSettingsModel?> call() async {
    return await repository.getAppsettings();
  }
}
