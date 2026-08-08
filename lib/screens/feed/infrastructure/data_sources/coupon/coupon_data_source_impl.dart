import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/coupon/coupon_data_source.dart';

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  final Dio dio;

  CouponRemoteDataSourceImpl(this.dio);

  @override
  Future<bool> isDeliveryCoupon(String couponCode) async {
    try {
      Response response = await api.post(
        "api/ufc/v1/is_delivery_coupon",
        data: {"coupon_code": couponCode},
          options:
            Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
      );
      final data = response.data;
      return (data is Map && data['is_delivery'] == true);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CouponModel> validateCoupon(String couponCode,
      {double? deliveryFee}) async {
    try {
      final isDelivery = await isDeliveryCoupon(couponCode);
      Response response = await api.post(
        "api/ufc/v1/validate_coupon",
        data: {
          "coupon_code": couponCode,
          if (isDelivery) "delivery_fee": deliveryFee,
        },
         options:
            Options(headers: {"Authorization": "Bearer ${AppConfig.token}"}),
      );

      return CouponModel.fromJson(response.data["coupon"]);
    } catch (e) {
      rethrow;
    }
  }
}
