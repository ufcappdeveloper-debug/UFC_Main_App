import 'package:flutter_riverpod/flutter_riverpod.dart';

// enum PaymentStatus {
//   initial,
//   processing,
//   success,
//   failed
// }

// class PaymentState {
//   final PaymentStatus status;
//   final String errorMessage;
//   final String paymentUrl;

//   PaymentState ({required this.status, this.errorMessage = '', this.paymentUrl = ''});

//   PaymentState copyWith ({
//     PaymentStatus? status,
//     String? errorMessage,
//     String? paymentUrl
//   }) {
//     return PaymentState(
//       status: status ?? this.status,
//       errorMessage: errorMessage ?? this.errorMessage,
//       paymentUrl: paymentUrl ?? this.paymentUrl
//       );
//   }
// }

// class PaymentStateNotifier extends StateNotifier<PaymentState> {

//   PaymentStateNotifier() : super(PaymentState(status: PaymentStatus.initial));

//   Future<void> fetchPaymentUrl() async {
// try {
//   state = state.copyWith(status: PaymentStatus.initial, errorMessage: '');

//   Response response = await api.get("api/ufc/v1/......");

// } catch {

// }
//   }

// }

class PaymentState {
  final bool isPaymentSuccessful;
  final String message;

  PaymentState({required this.isPaymentSuccessful, required this.message});
}

final paymentProvider =
    StateNotifierProvider<PaymentStateNotifier, PaymentState>(
        (ref) => PaymentStateNotifier());

class PaymentStateNotifier extends StateNotifier<PaymentState> {
  PaymentStateNotifier()
      : super(PaymentState(isPaymentSuccessful: false, message: ''));

  void setPaymentStatus(bool isSuccessful, String message) {
    state = PaymentState(isPaymentSuccessful: isSuccessful, message: message);
  }
}
