import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/loyality_service.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_tier_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part 'user_tier.g.dart';

@Riverpod(keepAlive: true)
class UserTier extends _$UserTier {
  @override
  FutureOr<UserTierModel> build() async {
    return LoyalitySystemService().fetchUserTierList();
  }

  Future<void> fetchUserTierList() async {
    state = const AsyncValue.loading();
    try {
      state =
          AsyncValue.data(await LoyalitySystemService().fetchUserTierList());
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
