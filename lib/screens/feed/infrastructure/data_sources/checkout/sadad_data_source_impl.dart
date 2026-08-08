import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/checkout/sadad_data_source.dart';

class SadadRemoteDataSourceImpl implements SadadRemoteDataSource {
  final Dio dio;

  SadadRemoteDataSourceImpl(this.dio);

  @override
  Future<SadadUserInfo?> getUserInfo() async {
    try {
      Response response = await api.get(
        "api/ufc/v1/sadad/get_info", options: Options(
          headers: {"Authorization": "Bearer ${AppConfig.token}"},
        ),
      );
      if (response.data["data"] == null) return null;
      return SadadUserInfo.fromJson(response.data["data"]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SadadUserInfo?> updateUserInfo(Map<String, dynamic> data) async {
    try {
      Response response = await api.post(
        "api/ufc/v1/sadad/save_info",
        data: data,
        options: Options(
          headers: {"Authorization": "Bearer ${AppConfig.token}"},
        ),
      );
      return SadadUserInfo.fromJson(response.data["data"]);
    } catch (e) {
      rethrow;
    }
  }
}
