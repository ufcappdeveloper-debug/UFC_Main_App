import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/delivery_cost/delivery_cost_model.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/delivery_cost/delivery_cost_data_source.dart';

class DeliveryCostRemoteDataSourceImpl implements DeliveryCostRemoteDataSource {
  final Dio customDio;

  DeliveryCostRemoteDataSourceImpl()
      : customDio = Dio(BaseOptions(
          baseUrl: AppConfig.baseUrlForLogistics,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ))
          ..interceptors.addAll([
            AppInterceptor(),
          ]);

  @override
  Future<DeliveryCostResponse> calculateDeliveryCost(
      int shopId, int userAddressId) async {
    try {
      final response = await customDio.post(
        "/api/ufc-logistics/v1/admin/order/calculate-delivery-cost",
        data: {
          "shop_id": shopId,
          "user_address_id": userAddressId,
        },
        options:
            Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
      );

      return DeliveryCostResponse.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
