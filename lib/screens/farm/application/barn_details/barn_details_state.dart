import 'package:equatable/equatable.dart';
import 'package:ufc_mobile/screens/farm/domain/entities/barn/barn_details_res_model.dart';

// Base state
abstract class BarnDetailsState extends Equatable {
  const BarnDetailsState();

  @override
  List<Object?> get props => [];
}

// Initial state
class BarnDetailsInitial extends BarnDetailsState {}

// Loading state
class BarnDetailsLoading extends BarnDetailsState {}

// Loaded state
class BarnDetailsLoaded extends BarnDetailsState {
  final BornDetailsModel? barnDetails;
  final bool hasMore;

  const BarnDetailsLoaded(this.barnDetails, this.hasMore);

  @override
  List<Object?> get props => [barnDetails];
}

// Error state
class BarnDetailsError extends BarnDetailsState {
  final String message;

  const BarnDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
