import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/community_service.dart';
import 'package:ufc_mobile/models/community_models/channel_model/channel_list_model.dart';

part 'channel_riverpod.g.dart';

@Riverpod(keepAlive: true)
class ChannelRiverpod extends _$ChannelRiverpod {
  @override
  FutureOr<ChannelListResponseModel?> build() => null;

  Future<void> fetchChannels({int page = 1, String? searchValue}) async {
    state = const AsyncValue.loading();
    try {
      final channelListModel = await CommunityService()
          .getChannels(page: page, searchValue: searchValue);
      state = AsyncValue.data(channelListModel);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> loadChannels({int page = 1, String? searchValue}) async {
    try {
      final channelListModel = await CommunityService()
          .getChannels(page: page, searchValue: searchValue);
      final current = state.value;

      if (current == null) {
        state = AsyncValue.data(channelListModel);
      } else {
        final allChannels = current
            .copyWith(data: [...?current.data, ...?channelListModel.data]);
        state = AsyncValue.data(allChannels);
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}
