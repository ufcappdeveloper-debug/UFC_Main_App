import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/payment/payment_data_source.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;
  PaymentRemoteDataSourceImpl(this.dio);

  @override
  Future<BankDetailsModel> getBankDetails(int stationId) async {
    try {
      final response = await api.get(
        "api/ufc/v1/bank_details/$stationId",
      );

      return BankDetailsModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
