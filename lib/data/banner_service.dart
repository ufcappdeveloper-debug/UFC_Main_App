import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/banner_model.dart';

class BannerService {
  Future<BannerModel?> getBannerNotification() async {
    Response response = await api.get("api/ufc/v1/active-banner");
    return BannerModel.fromJson(response.data['banner']);
  }
}
