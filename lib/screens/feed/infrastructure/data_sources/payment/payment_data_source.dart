import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';

abstract class PaymentRemoteDataSource {
  Future<BankDetailsModel> getBankDetails(int stationId);
}
