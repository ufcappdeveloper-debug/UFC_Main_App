import 'package:ufc_mobile/screens/feed/domain/entities/app_setting/app_settings_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/app_setting_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/app_setting/app_setting_data_source.dart';

class AppSettingRepositoryImpl implements AppSettingRepository {
  final AppSettingRemoteDataSource remoteDataSource;
  AppSettingRepositoryImpl(this.remoteDataSource);

  @override
  Future<AppSettingsModel?> getAppsettings() async {
    try {
      final result = await remoteDataSource.getAppsettings();

      return result;
   } catch (e) {
      rethrow;
    }
  }
}
