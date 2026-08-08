import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';
import 'package:ufc_mobile/screens/feed/domain/repositories/payment_repo.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/payment/payment_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  PaymentRepositoryImpl(this.remoteDataSource);

 

  @override
  Future<BankDetailsModel?> getBankDetails(int stationId) {
     return remoteDataSource.getBankDetails(stationId);
    
  }
  
  @override
  Future<bool?> verifyPayment(String checkoutId) {
    // TODO: implement verifyPayment
    throw UnimplementedError();
  }

 
}
