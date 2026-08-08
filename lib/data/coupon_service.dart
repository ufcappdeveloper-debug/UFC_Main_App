// import 'package:ufc_mobile/config/dio_intrepters.dart';
// import 'package:ufc_mobile/models/coupon_model.dart';

// class CouponService {
//   Future<CouponModel> validateCoupon(final data) async {
//     final response = await api.post("api/ufc/v1/validate_coupon", data: data);
//     return CouponModel.fromJson(response.data["coupon"]);
//   }
// }

import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/coupon/coupon_model.dart';

class CouponService {
  Future<CouponModel> validateCoupon(final String couponCode,
      {double? deliveryFee}) async {
    try {
      final isDelivery = await _isDeliveryCoupon(couponCode);
      final response = await api.post(
        "api/ufc/v1/validate_coupon",
        data: {
          "coupon_code": couponCode,
          if (isDelivery) "delivery_fee": deliveryFee,
        },
      );
      return CouponModel.fromJson(response.data["coupon"]);
    } catch (e) {
      rethrow; // Re-throws the exception to indicate this method can throw
    }
  }

  Future<bool> _isDeliveryCoupon(final String couponCode) async {
    try {
      final response = await api.post(
        "api/ufc/v1/is_delivery_coupon",
        data: {"coupon_code": couponCode},
      );
      final data = response.data;
      return (data is Map && data['is_delivery'] == true);
    } catch (e) {
      debugPrint("Error checking if coupon is delivery coupon: $e");
      rethrow; // Propagate the error after logging
    }
  }
}
