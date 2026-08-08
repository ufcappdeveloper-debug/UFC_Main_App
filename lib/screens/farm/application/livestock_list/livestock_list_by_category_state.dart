part of 'livestock_list_by_category_cubit.dart';

sealed class LivestockListByCategoryState extends Equatable {
  const LivestockListByCategoryState();

  @override
  List<Object> get props => [];
}

final class LivestockListByCategoryInitial extends LivestockListByCategoryState {}
final class LivestockListByCategoryLoading extends LivestockListByCategoryState {}

class LivestockListByCategoryLoaded extends LivestockListByCategoryState {
  final AnimalData? animals;

  const LivestockListByCategoryLoaded(this.animals);
}

class LivestockListByCategoryError extends LivestockListByCategoryState {
  final String message;

  const LivestockListByCategoryError(this.message);
}
