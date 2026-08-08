import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/payment_repo.dart';

class GetBankDetailsUseCase {
  final PaymentRepository repository;
  GetBankDetailsUseCase(this.repository);

  Future<BankDetailsModel?> call(int stationId) {
    return repository.getBankDetails(stationId);
  }
}

class VerifyPaymentUseCase {
  final PaymentRepository repository;
  VerifyPaymentUseCase(this.repository);
  Future<void> call(String checkoutId) => repository.verifyPayment(checkoutId);
}
