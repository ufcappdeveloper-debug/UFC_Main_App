part of 'filter_cubit.dart';

class FilterState extends Equatable {
  final List<List> filterItems;
  final double filterPrice;
  FilterState({required this.filterItems, required this.filterPrice});

  FilterState copyWith({
   List<List>? filterItems,
   double? filterPrice
  }){
    return FilterState(filterItems: filterItems ?? this.filterItems,
    filterPrice: filterPrice ?? this.filterPrice);
  }

  @override
  List<Object> get props => [filterItems, filterPrice];
}

