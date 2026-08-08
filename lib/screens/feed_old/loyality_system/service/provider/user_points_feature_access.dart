import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/loyality_service.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part 'user_points_feature_access.g.dart';

@Riverpod(keepAlive: true)
class UserPointsFeatureAccess extends _$UserPointsFeatureAccess {
  @override
  Future<bool> build() async {
    return await _checkFeatureStatus();
  }

  // Helper method to check the feature status
  Future<bool> _checkFeatureStatus() async {
    try {
      await LoyalitySystemService().fetchUserTierPointsAndRewards();
      return true; // Feature enabled
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return false;
      } else {
        rethrow; // Rethrow other exceptions
      }
    } catch (e) {
      rethrow; // Rethrow other exceptions
    }
  }

  // Method to trigger status check and update state
  Future<void> updateFeatureStatus() async {
    state = const AsyncValue.loading();
    try {
      bool isEnabled = await _checkFeatureStatus();
      state = AsyncValue.data(isEnabled); // Update state with the result
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
