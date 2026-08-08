import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/coupon_service.dart';

import 'package:ufc_mobile/global/util/log/log_utils.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';

part "coupon_async_riverpod.g.dart";

@Riverpod(keepAlive: true)
class CouponAsync extends _$CouponAsync {
  @override
  FutureOr<CouponModel?> build() async {
    return null;
  }

  Future<CouponModel> validateCoupon(
      String couponCode, double? deliveryFee) async {
    try {
      return await CouponService()
          .validateCoupon(couponCode, deliveryFee: deliveryFee);
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      debugLog(e.toString());
      rethrow;
    }
  }
}
