import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';

abstract class CouponRepository {
  Future<CouponModel> validateCoupon(String couponCode, {double? deliveryFee});
  Future<bool> isDeliveryCoupon(final String couponCode);
}
