import 'package:equatable/equatable.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/payment/bank_details_model.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final BankDetailsModel bankDetails;

  const PaymentLoaded(this.bankDetails);
}

class PaymentError extends PaymentState {
  final Object message;

  const PaymentError(this.message);
}
