import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/main.dart';

import '../../domain/entities/distributor/distributor_model.dart';
import '../../domain/entities/main_source/business_config_model.dart';
import '../business_config/business_config_cubit.dart';
import 'feed_channel_state.dart';

/// Remembers which feed channel (station / distributor) the user picked on
/// Home. The distributor itself is NOT saved: every "Buy from Distributor"
/// shows all distributors to choose from; the choice lives for the session.
///
/// In Main Source mode the channel is forced to [FeedChannel.mainSource]
/// (never saved); in marketplace mode a disabled channel is never kept.
class FeedChannelCubit extends Cubit<FeedChannelState> {
  static const _channelKey = 'feed_channel';

  /// Saved by earlier versions; removed so no "preferred distributor" stays.
  static const _legacyDistributorKey = 'selected_distributor';

  StreamSubscription<BusinessConfigModel>? _configSub;
  BusinessConfigModel? _config;

  FeedChannelCubit({BusinessConfigCubit? businessConfig})
      : super(const FeedChannelState()) {
    _restore();
    if (businessConfig != null) {
      applyBusinessConfig(businessConfig.state.config);
      _configSub = businessConfig.stream
          .map((s) => s.config)
          .distinct()
          .listen(applyBusinessConfig);
    }
  }

  FeedChannel _savedChannel() {
    try {
      return preferences.getString(_channelKey) == 'distributor'
          ? FeedChannel.distributor
          : FeedChannel.station;
    } catch (_) {
      return FeedChannel.station;
    }
  }

  void _restore() {
    try {
      preferences.remove(_legacyDistributorKey);
      emit(FeedChannelState(channel: _savedChannel()));
    } catch (_) {
      emit(const FeedChannelState());
    }
  }

  bool get _mainSourceForced => _config?.isMainSource ?? false;

  /// Keeps the channel in line with the enabled businesses.
  void applyBusinessConfig(BusinessConfigModel config) {
    _config = config;
    if (config.isMainSource) {
      if (!state.isMainSource) {
        emit(const FeedChannelState(channel: FeedChannel.mainSource));
      }
      return;
    }
    var channel = state.isMainSource ? _savedChannel() : state.channel;
    if (channel == FeedChannel.station &&
        !config.stationsEnabled &&
        config.distributorsEnabled) {
      channel = FeedChannel.distributor;
    } else if (channel == FeedChannel.distributor &&
        !config.distributorsEnabled &&
        config.stationsEnabled) {
      channel = FeedChannel.station;
    }
    if (channel != state.channel) {
      emit(FeedChannelState(channel: channel, pickRequest: state.pickRequest));
    }
  }

  Future<void> setChannel(FeedChannel channel) async {
    // Main Source mode: no Station / Distributor choice.
    if (_mainSourceForced || channel == FeedChannel.mainSource) return;
    emit(state.copyWith(channel: channel));
    await preferences.setString(_channelKey, channel.name);
  }

  /// "Buy from Distributor": clear the current distributor and ask the
  /// products page to show the distributors list.
  Future<void> startDistributorSelection() async {
    if (_mainSourceForced) return;
    emit(FeedChannelState(
      channel: FeedChannel.distributor,
      pickRequest: state.pickRequest + 1,
    ));
    await preferences.setString(_channelKey, FeedChannel.distributor.name);
  }

  /// The distributor chosen in the list (this session only).
  void selectDistributor(DistributorModel distributor) =>
      emit(state.copyWith(distributor: distributor));

  Future<void> clear() async {
    emit(const FeedChannelState());
    await preferences.remove(_channelKey);
    final config = _config;
    if (config != null) applyBusinessConfig(config);
  }

  @override
  Future<void> close() {
    _configSub?.cancel();
    return super.close();
  }
}
