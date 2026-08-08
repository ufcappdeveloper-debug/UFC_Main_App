import 'package:equatable/equatable.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteAddRemLoad extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteActionSuccess extends FavoriteState {
  final bool isFavorite; 
  final int productId;

  const FavoriteActionSuccess(this.isFavorite, this.productId);
}

class FavoriteLoaded extends FavoriteState {
  final List<ProductModel> products;
  final int currentPage;
  final int lastPage;
  final bool hasReachedEnd;
  final String? toggleFavMsg;

  const FavoriteLoaded({
    required this.products,
    required this.currentPage,
    required this.lastPage,
    this.hasReachedEnd = false,
    this.toggleFavMsg
  });

  FavoriteLoaded copyWith({
    List<ProductModel>? products,
    int? currentPage,
    int? lastPage,
    bool? hasReachedEnd,
  }) {
    return FavoriteLoaded(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class FavoriteError extends FavoriteState {
  final Object message;

  const FavoriteError(this.message);
}
