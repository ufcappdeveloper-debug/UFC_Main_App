part of 'death_cubit.dart';
sealed class DeathState extends Equatable {
  const DeathState();

  @override
  List<Object> get props => [];
}

final class DeathInitial extends DeathState {}
final class DeathLoading extends DeathState {}

class DeathLoaded extends DeathState {
  final List<AnimalModel>? animals;
  final DonutChartModel? donutChart;
  final CardModel? lineChart;
  final bool hasMore;

  const DeathLoaded(
    this.animals,
    this.donutChart,
    this.lineChart,
    this.hasMore,
  );
}

class DeathLoadingMore extends DeathState {
  final List<AnimalModel>? animals;
  final DonutChartModel? donutChart;
  final CardModel? lineChart;
  final bool hasMore;

  const DeathLoadingMore(
    this.animals,
    this.donutChart,
    this.lineChart,
    this.hasMore,
  );
}

class DeathError extends DeathState {
  final String message;

  const DeathError(this.message);
}
