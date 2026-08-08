import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';

abstract class CouponRemoteDataSource {
  Future<CouponModel> validateCoupon(String couponCode, {double? deliveryFee});
  Future<bool> isDeliveryCoupon(String couponCode);
}
