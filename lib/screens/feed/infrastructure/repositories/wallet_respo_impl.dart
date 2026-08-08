

import '../../domain/entities/wallet/feed_query_model.dart';
import '../../domain/entities/wallet/feed_wallet_model.dart';
import '../../domain/repositories/wallet_repo.dart';
import '../data_sources/wallet_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FeedWalletModel>> getWalletTransactions(WalletQueryParams params) {
    return remoteDataSource.getWalletTransactions(params);
  }
}
