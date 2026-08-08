import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/transaction_service.dart';

import '../../models/recent_transaction_model.dart';

part "recent_transactions_provider.g.dart";

@riverpod
Future<List<Result>> recentTransactions(Ref ref) async {
  final result = await TransactionService().getLatestRecentTransactions();
  return result;
}
