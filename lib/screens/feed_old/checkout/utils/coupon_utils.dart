import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

class CouponUtils {
  static void handleError(BuildContext context, DioException error) {
    String message = error.dioMessage;

    if (message.contains('maximum usage')) {
      message =
          'This coupon is no longer available. Please use a different code!';
    }

    CustomSnackBar.message(context, message);
  }
}
