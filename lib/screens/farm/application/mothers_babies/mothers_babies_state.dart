part of 'mothers_babies_cubit.dart';

sealed class MothersBabiesState extends Equatable {
  const MothersBabiesState();

  @override
  List<Object> get props => [];
}

final class MothersBabiesInitial extends MothersBabiesState {}

final class MothersBabiesLoading extends MothersBabiesState {}

class MothersBabiesLoaded extends MothersBabiesState {
  final List<AnimalModel>? animals;
  final MothersBabiesChart? chart;
  final bool hasReachedMax;

  const MothersBabiesLoaded(
      this.animals
      , this.chart,
      this.hasReachedMax);
}


class MothersBabiesLoadingMore extends MothersBabiesState {
  final List<AnimalModel>? animals;
  final MothersBabiesChart? chart;
  final bool hasReachedMax;

  const MothersBabiesLoadingMore(
      this.animals,
      this.chart,
      this.hasReachedMax);
}

class MothersBabiesError extends MothersBabiesState {
  final String message;

  const MothersBabiesError(this.message);
}
