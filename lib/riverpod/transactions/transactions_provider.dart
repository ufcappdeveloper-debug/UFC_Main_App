import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/transaction_service.dart';
import 'package:ufc_mobile/models/recent_transaction_model.dart';

part "transactions_provider.g.dart";

@riverpod
class Transactions extends _$Transactions {
  late TransactionService _transactionService;
  @override
  FutureOr<List<RecentTransactionModel>> build() async {
    _transactionService = TransactionService();
    return [];
  }

  Future<void> updateWallet(final data) async {
    try {
      await _transactionService.updateWallet(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllTransactions() async {
    state = const AsyncValue.loading();
    try {
      final recentTransactionsList =
          await _transactionService.getAllRecentTransactions();
      state = AsyncValue.data(recentTransactionsList);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
