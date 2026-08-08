import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';

class AppSetting {
  Future<Map<String, String>?> getAppsettings() async {
    Response response = await api.get("api/ufc/v1/get_app_settings");
    
    // String? inActive;
    // if(response.data['app_settings']!=null && response.data['app_settings'].isNotEmpty){
    //   response.data['app_settings'].forEach((e){
    //   if(e['key']=='SADAD_STATUS') inActive=e['value'];
    // });
    // }
    // return inActive;

    Map<String, String>? statusMap;
    final appSettings = response.data['app_settings'];
    if (appSettings != null &&
        appSettings is List<dynamic> &&
        appSettings.isNotEmpty) {
      statusMap = {}; // Initialize the map
      response.data['app_settings'].forEach((e) {
        if (e['key'] == 'SADAD_STATUS') {
          statusMap?['SADAD_STATUS'] = e['value'];
        }
        if (e['key'] == 'MADA_STATUS') {
          statusMap?['MADA_STATUS'] = e['value'];
        }
        if (e['key'] == 'BANK_STATUS') {
          statusMap?['BANK_STATUS'] = e['value'];
        }
      });
    }

    return statusMap;
  }
}
