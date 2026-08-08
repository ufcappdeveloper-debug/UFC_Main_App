

import '../entities/wallet/feed_query_model.dart';
import '../entities/wallet/feed_wallet_model.dart';

abstract class WalletRepository {
  Future<List<FeedWalletModel>> getWalletTransactions(WalletQueryParams params);
}
