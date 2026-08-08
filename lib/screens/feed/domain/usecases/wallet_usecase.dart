
import '../entities/wallet/feed_query_model.dart';
import '../entities/wallet/feed_wallet_model.dart';
import '../repositories/wallet_repo.dart';

class GetWalletTransactionsUseCase {
  final WalletRepository repository;

  GetWalletTransactionsUseCase(this.repository);

  Future<List<FeedWalletModel>> call(WalletQueryParams params) {
    return repository.getWalletTransactions(params);
  }
}
