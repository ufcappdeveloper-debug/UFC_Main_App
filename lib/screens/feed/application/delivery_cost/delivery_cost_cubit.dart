import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/delivery_cost/delivery_cost_state.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/delivery_cost/delivery_cost_model.dart';
import 'package:ufc_mobile/screens/feed/domain/usecases/delivery_cost_usecase.dart';

class DeliveryCostCubit extends Cubit<DeliveryCostState> {
  final CalculateDeliveryCostUseCase calculateDeliveryCostUseCase;
  DeliveryCostResponse? deliveryCost;

  DeliveryCostCubit(this.calculateDeliveryCostUseCase)
      : super(DeliveryCostInitial());

  Future<void> calculateDeliveryCost({
    required int shopId,
    required int userAddressId,
  }) async {
    emit(DeliveryCostLoading());
    try {
      final response =
          await calculateDeliveryCostUseCase(shopId, userAddressId);
      deliveryCost = response;
      emit(DeliveryCostLoaded(response));
    } catch (e) {
      emit(DeliveryCostError(e.toString()));
    }
  }

  void reset() {
  deliveryCost = null;
  emit(DeliveryCostInitial());
}
}
