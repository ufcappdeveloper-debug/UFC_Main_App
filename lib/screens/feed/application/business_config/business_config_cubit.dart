import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufc_mobile/global/util/dio/business_mode_events.dart';
import 'package:ufc_mobile/main.dart';

import '../../domain/entities/main_source/business_config_model.dart';
import '../../domain/entities/main_source/main_source_model.dart';
import '../../domain/repositories/main_source_repo.dart';
import 'business_config_state.dart';

export 'business_config_state.dart';

/// Which business is enabled (plan §1). Loaded on every launch before the
/// app opens, again on resume after [staleAfter], and whenever a create
/// call returns `403 BUSINESS_MODE_DISABLED`.
class BusinessConfigCubit extends Cubit<BusinessConfigState> {
  static const cacheKey = 'business_config';
  static const staleAfter = Duration(minutes: 10);

  final MainSourceRepository repository;
  final SharedPreferences _prefs;
  final DateTime Function() _now;
  StreamSubscription<BusinessModeDisabledEvent>? _events;
  Future<void>? _inFlight;

  BusinessConfigCubit(
    this.repository, {
    SharedPreferences? prefs,
    Stream<BusinessModeDisabledEvent>? modeDisabledEvents,
    DateTime Function()? now,
  })  : _prefs = prefs ?? preferences,
        _now = now ?? DateTime.now,
        super(const BusinessConfigState()) {
    final cached = _readCache();
    if (cached != null) {
      emit(BusinessConfigState(
          status: BusinessConfigStatus.loading,
          config: cached,
          fromCache: true));
    }
    _events = (modeDisabledEvents ?? BusinessModeEvents.stream)
        .listen(_onModeDisabled);
  }

  BusinessConfigModel get config => state.config;
  bool get isMainSource => state.config.isMainSource;
  bool get stationsEnabled => state.config.stationsEnabled;
  bool get distributorsEnabled => state.config.distributorsEnabled;
  List<MainSourceModel> get mainSources => state.config.mainSources;

  /// Fetches the config. Concurrent calls share one request.
  Future<void> load() => _inFlight ??= _load().whenComplete(() {
        _inFlight = null;
      });

  Future<void> _load() async {
    emit(state.copyWith(status: BusinessConfigStatus.loading));
    try {
      final config = await repository.getBusinessConfig();
      await _writeCache(config);
      emit(state.copyWith(
        status: BusinessConfigStatus.loaded,
        config: config,
        fromCache: false,
        loadedAt: _now(),
      ));
    } catch (e) {
      // Offline: keep the cached value, or the backend defaults.
      emit(state.copyWith(
        status: BusinessConfigStatus.error,
        config: _readCache() ?? BusinessConfigModel.defaults,
        fromCache: true,
        error: e.toString(),
      ));
    }
  }

  /// Waits for a load already running, or loads when nothing was fetched
  /// in this session yet. Used right before opening the app.
  Future<void> ensureLoaded() {
    if (_inFlight != null) return _inFlight!;
    if (state.loadedAt != null) return Future.value();
    return load();
  }

  /// App came back to the foreground.
  Future<void> reloadIfStale() {
    final loadedAt = state.loadedAt;
    if (loadedAt != null && _now().difference(loadedAt) < staleAfter) {
      return Future.value();
    }
    return load();
  }

  void _onModeDisabled(BusinessModeDisabledEvent event) {
    emit(state.copyWith(
      modeDisabledEventId: state.modeDisabledEventId + 1,
      modeDisabledMessage: event.message,
    ));
    load();
  }

  BusinessConfigModel? _readCache() {
    try {
      final raw = _prefs.getString(cacheKey);
      if (raw == null || raw.isEmpty) return null;
      final json = jsonDecode(raw);
      return json is Map<String, dynamic>
          ? BusinessConfigModel.fromJson(json)
          : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(BusinessConfigModel config) async {
    try {
      await _prefs.setString(cacheKey, jsonEncode(config.toJson()));
    } catch (_) {
      // Caching is best effort.
    }
  }

  @override
  Future<void> close() {
    _events?.cancel();
    return super.close();
  }
}
