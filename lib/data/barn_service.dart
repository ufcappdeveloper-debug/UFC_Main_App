import 'package:dio/dio.dart';

import '../global/config/config.dart';
import '../global/util/dio/dio_intrepters.dart';
import '../screens/farm/domain/entities/barn/barn_model.dart';

class FarmDio {
  static final Dio farmDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.farmBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(AppInterceptor());

  static Dio get api => farmDio;
}

class BarnService {
  Future<List<BarnModel>> getBarns() async {
    Response response = await FarmDio.api.get("/api/ufc-farm/v1/user/barns");
    return (response.data["data"] as List<dynamic>)
        .map((data) => BarnModel.fromJson(data))
        .toList();
  }

  Future<BarnModel> addBarn(Map<String, dynamic> data, {int? editBarnId}) async {
    Response response = await FarmDio.api.post(
        editBarnId != null
            ? "/api/ufc-farm/v1/user/barns/$editBarnId/edit"
            : "/api/ufc-farm/v1/user/barns",
        data: data);
    return BarnModel.fromJson(response.data['data']);
  }

  Future<void> deleteBarn(int id) async {
    await FarmDio.api.delete("/api/ufc-farm/v1/user/barns/$id");
  }
}
