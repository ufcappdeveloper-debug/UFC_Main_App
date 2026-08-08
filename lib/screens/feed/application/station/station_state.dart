import 'package:equatable/equatable.dart';
import '../../domain/entities/station/station_model.dart';

abstract class StationState extends Equatable {
  const StationState();

  @override
  List<Object?> get props => [];
}

class StationInitial extends StationState {}

class StationLoading extends StationState {}

class StationLoaded extends StationState {
  final List<StationModel> stations;

  const StationLoaded(this.stations);

  @override
  List<Object?> get props => [stations];
}

class StationSuccess extends StationState {
  final String message;
  const StationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class StationError extends StationState {
  final Object message;

  const StationError(this.message);

  @override
  List<Object?> get props => [message];
}
