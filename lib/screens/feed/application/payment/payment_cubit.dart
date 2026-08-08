import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/payment/payment_state.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/payment_usecase.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final GetBankDetailsUseCase getBankDetailsUseCase;

  PaymentCubit(
    this.getBankDetailsUseCase,
  ) : super(PaymentInitial());

  Future<void> getBankDetails({required int stationId}) async {
    emit(PaymentLoading());
    try {
      final bankDetails = await getBankDetailsUseCase(stationId);

      if (bankDetails != null) {
        emit(PaymentLoaded(bankDetails));
      } else {
        emit(PaymentError("No bank details found."));
      }
    } catch (e) {
      emit(PaymentError(e));
    }
  }
}
