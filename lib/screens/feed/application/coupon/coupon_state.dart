import 'package:equatable/equatable.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';

abstract class CouponState extends Equatable {
  const CouponState();

  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponLoaded extends CouponState {
  final CouponModel? coupon;
  final bool? isDeliveryCoupon;

  const CouponLoaded({this.coupon, this.isDeliveryCoupon});
}

class CouponError extends CouponState {
  final Object message;

  const CouponError(this.message);
}
