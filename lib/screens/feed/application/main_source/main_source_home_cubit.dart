import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/main_source/main_source_model.dart';
import '../../domain/entities/main_source/main_source_product_model.dart';
import '../../domain/repositories/main_source_repo.dart';

class MainSourceHomeState extends Equatable {
  final MainSourceHomeModel? home;
  final bool loading;
  final Object? error;

  const MainSourceHomeState({this.home, this.loading = false, this.error});

  List<MainSourceModel> get mainSources => home?.mainSources ?? const [];
  List<MainSourceCategoryModel> get categories => home?.categories ?? const [];

  @override
  List<Object?> get props => [
        home?.mainSources.map((e) => e.id).join(','),
        home?.categories.map((e) => '${e.id}:${e.productsCount}').join(','),
        loading,
        error?.toString(),
      ];
}

/// `GET /main-source/home`: sources, their categories and the latest
/// products. Shared by the Home and Products tabs.
class MainSourceHomeCubit extends Cubit<MainSourceHomeState> {
  final MainSourceRepository repository;

  MainSourceHomeCubit(this.repository) : super(const MainSourceHomeState());

  Future<void> load({bool silent = false}) async {
    if (!silent || state.home == null) {
      emit(MainSourceHomeState(home: state.home, loading: true));
    }
    try {
      final home = await repository.getHome();
      emit(MainSourceHomeState(home: home));
    } catch (e) {
      emit(MainSourceHomeState(home: state.home, error: e));
    }
  }

  /// Loads once; later calls are no-ops while data is there.
  Future<void> ensureLoaded() async {
    if (state.home != null || state.loading) return;
    await load();
  }
}
