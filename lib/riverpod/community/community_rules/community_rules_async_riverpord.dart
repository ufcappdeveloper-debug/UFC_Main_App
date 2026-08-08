import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/community_service.dart';
import 'package:ufc_mobile/models/community_models/rules/community_rules_model.dart';
part 'community_rules_async_riverpord.g.dart';

@Riverpod(keepAlive: true)
class CommunityRulesRiverpod extends _$CommunityRulesRiverpod {
  @override
  FutureOr<List<CommunityRulesModel>?> build() => null;

  Future<void> fetchRules({int page = 1, String? searchValue}) async {
    state = const AsyncValue.loading();
    try {
      final channelListModel = await CommunityService().getRules(page: page);
      state = AsyncValue.data(channelListModel.rulesList);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> loadRules({int page = 1}) async {
    try {
      final channelListModel = await CommunityService().getRules(page: page);
      final current = state.value;

      if (current == null) {
        state = AsyncValue.data(channelListModel.rulesList);
      } else {
        final allRules = [...current, ...?channelListModel.rulesList];
        state = AsyncValue.data(allRules);
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}
