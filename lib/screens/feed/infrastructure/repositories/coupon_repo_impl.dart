import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/coupon_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/coupon/coupon_data_source.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponRemoteDataSource remoteDataSource;

  CouponRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> isDeliveryCoupon(String couponCode) {
    return remoteDataSource.isDeliveryCoupon(couponCode);
  }

  @override
  Future<CouponModel> validateCoupon(String couponCode, {double? deliveryFee}) async {
    return remoteDataSource.validateCoupon(couponCode,
        deliveryFee: deliveryFee);
  }
}
