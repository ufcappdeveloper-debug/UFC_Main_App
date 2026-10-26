import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/distributor/distributor_model.dart';
import '../../domain/entities/distributor/distributor_query_params.dart';
import '../../domain/repositories/distributor_repo.dart';

class DistributorListState extends Equatable {
  final List<DistributorModel> distributors;
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final String? error;
  final DistributorListParams params;

  const DistributorListState({
    this.distributors = const [],
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = false,
    this.error,
    this.params = const DistributorListParams(),
  });

  DistributorListState copyWith({
    List<DistributorModel>? distributors,
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    String? error,
    DistributorListParams? params,
  }) =>
      DistributorListState(
        distributors: distributors ?? this.distributors,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        hasMore: hasMore ?? this.hasMore,
        error: error,
        params: params ?? this.params,
      );

  @override
  List<Object?> get props =>
      [distributors, loading, loadingMore, hasMore, error, params.page, params.search];
}

/// Distributor list for the "Feed Distributors" sheet (like the stations
/// sheet: `get_distributors`, distance computed on the device).
class DistributorListCubit extends Cubit<DistributorListState> {
  final DistributorRepository repository;

  DistributorListCubit(this.repository) : super(const DistributorListState());

  Future<Position?> _position() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getLastKnownPosition() ??
          await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.medium)
              .timeout(const Duration(seconds: 8));
    } catch (_) {
      return null;
    }
  }

  Position? _userPosition;

  /// Same as the stations sheet: the full list in the API's order. The list
  /// never waits for the GPS; distances are filled in once a position is
  /// known.
  Future<void> load({String? search}) async {
    emit(state.copyWith(loading: true, distributors: []));
    final params = DistributorListParams(search: search ?? state.params.search);
    try {
      final page = await repository.getDistributors(params);
      debugPrint('[Distributors] loaded ${page.items.length} '
          '(page ${page.currentPage}/${page.lastPage})');
      emit(state.copyWith(
        loading: false,
        distributors: _withDistance(page.items),
        hasMore: page.hasMore,
        params: params,
      ));
    } catch (e) {
      debugPrint('[Distributors] load failed: $e');
      emit(state.copyWith(loading: false, error: e.toString(), params: params));
    }
    _locate();
  }

  Future<void> _locate() async {
    if (_userPosition != null) return;
    _userPosition = await _position();
    if (_userPosition == null || isClosed || state.distributors.isEmpty) {
      return;
    }
    emit(state.copyWith(distributors: _withDistance([...state.distributors])));
  }

  /// Fills `distance` (km) where both locations are known.
  List<DistributorModel> _withDistance(List<DistributorModel> items) {
    final me = _userPosition;
    if (me == null) return items;
    for (final d in items) {
      if (d.distance == null && d.hasLocation) {
        d.distance = Geolocator.distanceBetween(
                me.latitude, me.longitude, d.latitude!, d.longitude!) /
            1000;
      }
    }
    return items;
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore || state.loading) return;
    emit(state.copyWith(loadingMore: true));
    final params = state.params.copyWith(page: state.params.page + 1);
    try {
      final page = await repository.getDistributors(params);
      emit(state.copyWith(
        loadingMore: false,
        distributors: _withDistance([...state.distributors, ...page.items]),
        hasMore: page.hasMore,
        params: params,
      ));
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e.toString()));
    }
  }
}
