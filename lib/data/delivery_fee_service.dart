// import 'package:dio/dio.dart';
// import 'package:ufc_mobile/config/dio_intrepters.dart';
// import 'package:ufc_mobile/riverpod/order/delivery_cost.dart';

// class DeliveryCostService {
//   Future<DeliveryCostResponse> calculateDeliveryCost({
//     required int userAddressId,
//     required int shopId,
//   }) async {
//     Response response = await api.post(
//       "/api/ufc-logistics/v1/admin/order/calculate-delivery-cost",
//       data: {
//         "user_address_id": userAddressId,
//         "shop_id": shopId,
//       },
//     );

//     if (response.data['status'] == 'success') {
//       return response.data['data']['total_cost'];
//     } else {
//       throw Exception("Failed to calculate delivery cost");
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/riverpod/order/delivery_cost.dart';

class DeliveryCostService {
  final Dio _customDio;

  DeliveryCostService()
      : _customDio = Dio(BaseOptions(
          baseUrl: AppConfig.baseUrlForLogistics,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ))
          ..interceptors.addAll([
            AppInterceptor(),
          ]);

  Future<DeliveryCostResponse> calculateDeliveryCost({
    required int shopId,
    required int userAddressId,
  }) async {
    try {
      Response response = await _customDio.post(
        "/api/ufc-logistics/v1/admin/order/calculate-delivery-cost",
        data: {
          "shop_id": shopId,
          "user_address_id": userAddressId,
        },
      );

      if (response.data['status'] == 'success') {
        return DeliveryCostResponse.fromJson(response.data['data']);
      } else {
        throw Exception(
            "Failed to calculate delivery cost: ${response.data['message']}");
      }
    } catch (e) {
      throw Exception("Error calculating delivery cost: $e");
    }
  }
}
