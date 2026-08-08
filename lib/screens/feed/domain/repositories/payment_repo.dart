import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';

abstract class PaymentRepository {
  Future<BankDetailsModel?> getBankDetails(int stationId);
  Future<bool?> verifyPayment(String checkoutId);
}
