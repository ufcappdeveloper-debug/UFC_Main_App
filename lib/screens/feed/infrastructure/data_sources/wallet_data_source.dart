import '../../domain/entities/wallet/feed_query_model.dart';
import '../../domain/entities/wallet/feed_wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<List<FeedWalletModel>> getWalletTransactions(WalletQueryParams params);
}