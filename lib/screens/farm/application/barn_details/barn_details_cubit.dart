import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/screens/farm/application/barn_details/barn_details_state.dart';
import 'package:ufc_mobile/screens/farm/domain/usecase/barn_details_usecase.dart';

import '../../../feed/domain/failure/failure.dart';
import '../../domain/usecase/update_feed_quantity_usecase.dart';

class BarnDetailsCubit extends Cubit<BarnDetailsState> {
  final GetBarnDetailsUseCase getBarnDetailsUseCase;
  final UpdateFeedQuantityUsecase updateFeedQuantityUsecase;

  BarnDetailsCubit(this.getBarnDetailsUseCase, this.updateFeedQuantityUsecase)
      : super(BarnDetailsInitial());

  int page = 1;
  int limit = 30;
  bool hasMore = true;
  Map<String, dynamic> filter = {};

  Future<void> fetchBarnDetails(int barnId,
      {bool loadMore = false, String? animalCategory, bool? allBarn}) async {
    if (!loadMore) {
      page = 1;
      hasMore = true;
      emit(BarnDetailsLoading());
    } else {
      page++;
    }

    try {
      final barn = await getBarnDetailsUseCase(barnId, {
        'page': page,
        'per_page': limit,
        if (animalCategory != null) 'category': animalCategory,
        if (allBarn == true) 'all_barns': 1,
        if (filter.isNotEmpty) ...filter
      });

      if (barn.data?.animals == null || barn.data!.animals!.isEmpty) {
        hasMore = false;
      }

      if (state is BarnDetailsLoaded && loadMore) {
        final loadedState = state as BarnDetailsLoaded;
        final currentBarnDetails = loadedState.barnDetails;
        final currentAnimals = currentBarnDetails?.animals ?? [];
        final newAnimals = [...currentAnimals, ...?barn.data?.animals];

        emit(BarnDetailsLoaded(
            currentBarnDetails?.copyWith(animals: newAnimals) ?? barn.data!,
            hasMore));
      } else {
        emit(BarnDetailsLoaded(barn.data, hasMore));
      }
    } catch (e) {
      emit(BarnDetailsError(e.toString()));
    }
  }

  Future<String?> updateFeed(int barnId, int quantity) async {
    try {
      await updateFeedQuantityUsecase(barnId, quantity);
      await fetchBarnDetails(barnId);
      return null;
    } on Failure catch (f) {
      return f.message;
    } catch (e) {
      return e.toString();
    }
  }

  void clearState() {
    filter = {};
    page = 1;
    hasMore = true;
    emit(BarnDetailsInitial());
  }
}
