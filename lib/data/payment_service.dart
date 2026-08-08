import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';

class PaymentService {
  static Future<BankDetailsModel?> getBankDetails(final int stationId) async {
    Response response = await api.get("api/ufc/v1/bank_details/$stationId");
    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      return BankDetailsModel.fromJson(data);
    }
    return null;
  }

  static Future<bool> verifyPayment(final String checkoutId) async {
    try {
      final response = await api.get("api/ufc/v1/verify_payment/$checkoutId");

      bool isSuccess = response.data?['message']
              ?.contains('Request successfully processed') ??
          false;
      if (!isSuccess) {
        Sentry.captureMessage(
          'Payment verification failed: ${response.data}',
          level: SentryLevel.info,
        );
      }

      return isSuccess;
    } catch (e) {
      Sentry.captureException(e);
      return false;
    }
  }
}
