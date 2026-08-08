import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/coupon/coupon_state.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/coupon_usecase.dart';

class CouponCubit extends Cubit<CouponState> {
  final ValidateCouponUseCase validateCouponUseCase;
  final DeliveryCouponUseCase deliveryCouponUseCase;

  CouponCubit(this.validateCouponUseCase, this.deliveryCouponUseCase)
      : super(CouponInitial());

  Future<void> validateCoupon(final String couponCode,
      {double? deliveryFee}) async {
    emit(CouponLoading());

    try {
      final response =
          await validateCouponUseCase(couponCode, deliveryFee: deliveryFee);
      emit(CouponLoaded(coupon: response));
      inspect(response);
    } catch (e) {
      emit(CouponError(e));
    }
  }

  Future<void> isDeliveryCoupon(
    final String couponCode,
  ) async {
    try {
      emit(CouponLoading());

      final response = await deliveryCouponUseCase(couponCode);
      inspect(response);

      emit(CouponLoaded(isDeliveryCoupon: response));
    } catch (e) {
      emit(CouponError(e));
    }
  }
}
