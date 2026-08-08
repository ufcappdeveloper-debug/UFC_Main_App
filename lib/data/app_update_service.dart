import 'package:dio/dio.dart';

import '../global/config/dio.dart';
import '../models/app_update_model.dart';

class AppUpdateService {
  Future<AppUpdateModel> getLatestAppUpdate() async {
    Response res = await api.get("api/ufc/v1/getLatestUpdate");
    AppUpdateModel model = AppUpdateModel.fromJson(res.data["app_update"]);
    return model;
  }
}
