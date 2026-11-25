import 'package:equatable/equatable.dart';

import '../../domain/entities/distributor/distributor_model.dart';

/// [mainSource] is forced by the business config (plan §7.1); it is never
/// chosen by the user.
enum FeedChannel { station, distributor, mainSource }

class FeedChannelState extends Equatable {
  final FeedChannel channel;

  /// Distributor chosen in this session (never saved).
  final DistributorModel? distributor;

  /// Bumped on every "Buy from Distributor" so the products page opens the
  /// distributors list.
  final int pickRequest;

  const FeedChannelState({
    this.channel = FeedChannel.station,
    this.distributor,
    this.pickRequest = 0,
  });

  bool get isDistributor => channel == FeedChannel.distributor;
  bool get isMainSource => channel == FeedChannel.mainSource;

  FeedChannelState copyWith({
    FeedChannel? channel,
    DistributorModel? distributor,
  }) =>
      FeedChannelState(
        channel: channel ?? this.channel,
        distributor: distributor ?? this.distributor,
        pickRequest: pickRequest,
      );

  @override
  List<Object?> get props => [channel, distributor?.id, pickRequest];
}
