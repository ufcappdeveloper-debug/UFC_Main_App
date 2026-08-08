import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/screens/feed/infrastructure/data_sources/wallet_data_source.dart';

import '../../domain/entities/wallet/feed_query_model.dart';
import '../../domain/entities/wallet/feed_wallet_model.dart';

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio dio;

  WalletRemoteDataSourceImpl(this.dio);

  @override
  Future<List<FeedWalletModel>> getWalletTransactions(WalletQueryParams params) async {
    int timeZone = DateTime.now().timeZoneOffset.inHours;

    final response = await api.get(
      "/api/ufc/v1/wallet/get_wallet_transaction?time_zone=$timeZone",
    );

    print("✅ API Response for wallet: ${response.data}");

    final data = response.data['data'] as List;
    final transactions = data.map((json) => FeedWalletModel.fromJson(json)).toList();

    print("✅ Parsed Wallet Transactions: $transactions");
    return transactions;

  }
}