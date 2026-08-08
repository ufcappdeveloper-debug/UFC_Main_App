part of 'livestock_details_cubit.dart';

abstract class LiveStockDetailsState extends Equatable {
  const LiveStockDetailsState();

  @override
  List<Object?> get props => [];
}

final class LiveStockDetailsInitial extends LiveStockDetailsState {}

// Loading state
class LiveStockDetailsLoading extends LiveStockDetailsState {}

// Loaded state
class LiveStockDetailsLoaded extends LiveStockDetailsState {
  final LiveStockDetailsModel? liveStockDetails;
  final ReportResponse? livestockReportModel;
  final List<AppSettingsKeyAndValue> reportsKeyAndValue;
  const LiveStockDetailsLoaded(
    this.liveStockDetails,
    this.livestockReportModel,
    this.reportsKeyAndValue,
  );

  @override
  List<Object?> get props => [liveStockDetails];
}

// Error state
class LiveStockDetailsError extends LiveStockDetailsState {
  final String message;

  const LiveStockDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
