import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';

class SadadService {
  Future<SadadUserInfo?> getSadadUserInfo() async {
    Response response = await api.get("api/ufc/v1/sadad/get_info");
    if (response.data["data"] == null) return null;
    return SadadUserInfo.fromJson(response.data["data"]);
  }

  Future<SadadUserInfo?> updateSadadUserInfo(final data) async {
    Response response =
        await api.post("api/ufc/v1/sadad/save_info", data: data);
    return SadadUserInfo.fromJson(response.data["data"]);
  }
}
