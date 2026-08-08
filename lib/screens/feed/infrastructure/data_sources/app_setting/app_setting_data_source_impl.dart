import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/app_setting/app_settings_model.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/app_setting/app_setting_data_source.dart';

class AppSettingRemoteDataSourceImpl implements AppSettingRemoteDataSource {
  final Dio dio;

  AppSettingRemoteDataSourceImpl(this.dio);

  @override
  Future<AppSettingsModel?> getAppsettings() async {
    try {
      Response response = await api.get(
        "api/ufc/v1/get_app_settings",
      );
      if (response.data == null) return null;
      return AppSettingsModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
