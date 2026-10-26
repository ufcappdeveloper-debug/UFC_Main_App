import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/main.dart';

import '../../domain/entities/distributor/distributor_model.dart';
import 'feed_channel_state.dart';

/// Remembers which feed channel (station / distributor) the user picked on
/// Home. The distributor itself is NOT saved: every "Buy from Distributor"
/// shows all distributors to choose from; the choice lives for the session.
class FeedChannelCubit extends Cubit<FeedChannelState> {
  static const _channelKey = 'feed_channel';

  /// Saved by earlier versions; removed so no "preferred distributor" stays.
  static const _legacyDistributorKey = 'selected_distributor';

  FeedChannelCubit() : super(const FeedChannelState()) {
    _restore();
  }

  void _restore() {
    try {
      preferences.remove(_legacyDistributorKey);
      final channel = preferences.getString(_channelKey) == 'distributor'
          ? FeedChannel.distributor
          : FeedChannel.station;
      emit(FeedChannelState(channel: channel));
    } catch (_) {
      emit(const FeedChannelState());
    }
  }

  Future<void> setChannel(FeedChannel channel) async {
    emit(state.copyWith(channel: channel));
    await preferences.setString(_channelKey, channel.name);
  }

  /// "Buy from Distributor": clear the current distributor and ask the
  /// products page to show the distributors list.
  Future<void> startDistributorSelection() async {
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
  }
}
