import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/coupon_repo.dart';

class ValidateCouponUseCase {
  final CouponRepository repository;

  ValidateCouponUseCase(this.repository);

  Future<CouponModel> call(String couponCode, {double? deliveryFee}) {
    return repository.validateCoupon(couponCode, deliveryFee: deliveryFee);
  }
}

class DeliveryCouponUseCase {
  final CouponRepository repository;

  DeliveryCouponUseCase(this.repository);

  Future<bool> call(String couponCode) {
    return repository.isDeliveryCoupon(couponCode);
  }
}
