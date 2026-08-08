import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/feed/application/product_rating/rating_state.dart';

import '../../domain/usecases/add_review_usecase.dart';
import '../../domain/usecases/product_rating_usecase.dart';

class ProductRatingCubit extends Cubit<ProductRatingState> {
  final GetProductRatingsUseCase getRatingsUseCase;
  final AddProductRatingUseCase addRatingUseCase;

  ProductRatingCubit(this.getRatingsUseCase, this.addRatingUseCase)
      : super(ProductRatingInitial());

  Future<void> fetchRatings({required int productId, int page = 1, int limit = 10}) async {
    emit(ProductRatingLoading());
    try {
      final ratings = await getRatingsUseCase.call(
        productId: productId,
        page: page,
        limit: limit,
      );
      emit(ProductRatingLoaded(ratings));
    } catch (e) {
      emit(ProductRatingError(e.toString()));
    }
  }

  Future<void> submitRating({
    required int productId,
    required int rating,
    required String review,
  }) async {
    try {
      await addRatingUseCase(
        productId: productId,
        rating: rating,
        review: review,
      );
      emit(ProductRatingSubmitSuccess());
    } on DioError catch (e) {
      final errorMessage = e.response?.data['message'] ?? "Failed to submit review.";
      emit(ProductRatingSubmitError(errorMessage));
    } catch (e) {
      emit(ProductRatingSubmitError("Failed to submit review."));
    }
  }

}