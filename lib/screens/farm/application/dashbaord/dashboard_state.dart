part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

// Loading state
class DashboardLoading extends DashboardState {}

// Loaded state
class DashboardLoaded extends DashboardState {
  final DashboardResponseModel? dashboardData;

  const DashboardLoaded(this.dashboardData);

  @override
  List<Object> get props => [dashboardData!];
}

// Error state
class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
