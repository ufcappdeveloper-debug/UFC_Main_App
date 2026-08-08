import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/category_usecase.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryCubit(this.getCategoriesUseCase) : super(CategoryInitial());

  Future<void> fetchCategories({int page = 1, int limit = 20}) async {
    emit(CategoryLoading());
    try {
      final categories = await getCategoriesUseCase({
        "page": page,
        "limit": limit,
      });
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e));
    }
  }
}
