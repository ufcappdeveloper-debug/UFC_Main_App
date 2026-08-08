// application/product_rating/product_rating_cubit.dart

import '../../domain/entities/product/product_rating_model.dart';

abstract class ProductRatingState {}

class ProductRatingInitial extends ProductRatingState {}

class ProductRatingLoading extends ProductRatingState {}

class ProductRatingLoaded extends ProductRatingState {
  final List<ReviewModel> ratings;

  ProductRatingLoaded(this.ratings);
}

class ProductRatingError extends ProductRatingState {
  final String message;

  ProductRatingError(this.message);
}

class ProductRatingSubmitting extends ProductRatingState {}

class ProductRatingSubmitSuccess extends ProductRatingState {}

class ProductRatingSubmitError extends ProductRatingState {
  final String message;

  ProductRatingSubmitError(this.message);
}
