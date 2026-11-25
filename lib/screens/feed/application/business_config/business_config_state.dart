import 'package:equatable/equatable.dart';

import '../../domain/entities/main_source/business_config_model.dart';

enum BusinessConfigStatus { loading, loaded, error }

/// [config] is always usable: the fresh value, the cached one, or the
/// backend defaults (marketplace with both cards).
class BusinessConfigState extends Equatable {
  final BusinessConfigStatus status;
  final BusinessConfigModel config;

  /// [config] did not come from the server in this session.
  final bool fromCache;
  final String? error;

  /// Last successful fetch (for the resume check).
  final DateTime? loadedAt;

  /// Bumped on every `403 BUSINESS_MODE_DISABLED`; the UI shows the
  /// message and goes back to Home.
  final int modeDisabledEventId;
  final String? modeDisabledMessage;

  const BusinessConfigState({
    this.status = BusinessConfigStatus.loading,
    this.config = BusinessConfigModel.defaults,
    this.fromCache = true,
    this.error,
    this.loadedAt,
    this.modeDisabledEventId = 0,
    this.modeDisabledMessage,
  });

  bool get isLoading => status == BusinessConfigStatus.loading;
  bool get isMainSource => config.isMainSource;

  BusinessConfigState copyWith({
    BusinessConfigStatus? status,
    BusinessConfigModel? config,
    bool? fromCache,
    String? error,
    DateTime? loadedAt,
    int? modeDisabledEventId,
    String? modeDisabledMessage,
  }) =>
      BusinessConfigState(
        status: status ?? this.status,
        config: config ?? this.config,
        fromCache: fromCache ?? this.fromCache,
        error: error,
        loadedAt: loadedAt ?? this.loadedAt,
        modeDisabledEventId: modeDisabledEventId ?? this.modeDisabledEventId,
        modeDisabledMessage: modeDisabledMessage ?? this.modeDisabledMessage,
      );

  @override
  List<Object?> get props => [
        status,
        config,
        fromCache,
        error,
        loadedAt,
        modeDisabledEventId,
        modeDisabledMessage,
      ];
}
