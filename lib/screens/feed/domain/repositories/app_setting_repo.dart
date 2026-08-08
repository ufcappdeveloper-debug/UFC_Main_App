import 'package:ufc_mobile/screens/feed/domain/entities/app_setting/app_settings_model.dart';

abstract class AppSettingRepository {
  Future<AppSettingsModel?> getAppsettings();
}
