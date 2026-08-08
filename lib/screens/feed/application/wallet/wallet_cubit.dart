import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wallet/feed_query_model.dart';
import '../../domain/usecases/wallet_usecase.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final GetWalletTransactionsUseCase getWalletTransactionsUseCase;

  WalletCubit(this.getWalletTransactionsUseCase) : super(WalletInitial());

  Future<void> fetchWalletTransactions(String timeZone) async {
    emit(WalletLoading());
    try {
      final transactions = await getWalletTransactionsUseCase(
        WalletQueryParams(timeZone: timeZone),
      );
      emit(WalletLoaded(transactions));
    } catch (e) {
      emit(WalletError(e));
    }
  }
}
