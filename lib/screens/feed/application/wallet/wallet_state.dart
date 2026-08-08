import 'package:equatable/equatable.dart';

import '../../domain/entities/wallet/feed_wallet_model.dart';


abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List<FeedWalletModel> transactions;
  const WalletLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class WalletError extends WalletState {
  final Object message;
  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
