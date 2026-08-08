import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/recent_transaction_model.dart';

class TransactionService {
  Future<String> updateWallet(final data) async {
    Response response =
        await api.post("api/ufc/v1/wallet/update_wallet", data: data);
    return response.data['message'];
  }

  Future<List<RecentTransactionModel>> getAllRecentTransactions() async {
    int timeZone = DateTime.now().timeZoneOffset.inHours;
    Response response = await api
        .get("api/ufc/v1/wallet/get_wallet_transaction?time_zone=$timeZone");
    final transactionsModel = (response.data['data'] as List<dynamic>)
        .map((e) => RecentTransactionModel.fromJson(e))
        .toList();
    return transactionsModel;
  }

  Future<List<Result>> getLatestRecentTransactions() async {
    Response response =
        await api.get("api/ufc/v1/wallet/get_recent_transaction");
    final transactionsModel = (response.data['data'] as List<dynamic>)
        .map((e) => Result.fromJson(e))
        .toList();
    return transactionsModel;
  }

  Future<void> placeOrder() async {
    Response response = await api.post(
      "api/ufc/v1/place_order",
      // data: data,
    );
    return response.data['data'];
  }
}
