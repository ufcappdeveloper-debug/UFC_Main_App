import 'package:equatable/equatable.dart';

import '../../domain/entities/distributor/distributor_model.dart';

enum FeedChannel { station, distributor }

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
