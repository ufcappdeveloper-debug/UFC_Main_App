import 'package:equatable/equatable.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/delivery_cost/delivery_cost_model.dart';


abstract class DeliveryCostState extends Equatable {
  const DeliveryCostState();

  @override
  List<Object?> get props => [];
}

class DeliveryCostInitial extends DeliveryCostState {}

class DeliveryCostLoading extends DeliveryCostState {}

class DeliveryCostLoaded extends DeliveryCostState {
  final DeliveryCostResponse? deliveryCost;

  const DeliveryCostLoaded(this.deliveryCost);
  
}

class DeliveryCostError extends DeliveryCostState {
  final String message;

  const DeliveryCostError(this.message);
}
