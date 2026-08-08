import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/app_setting_service.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part 'app_setting_riverpod.g.dart';

@riverpod
class AppSettingRiverpod extends _$AppSettingRiverpod {
  @override
  FutureOr<Map<String, String>?> build() async {
    // Initially returning null or an empty map since it's the default state
    return null; // or you could return an empty map, depending on your needs.
  }

  Future<void> getAppSetting() async {
    state = const AsyncValue.loading(); // Set loading state
    try {
      final result = await AppSetting().getAppsettings();
      // If result is valid, update state with the fetched map
      state = AsyncValue.data(result);
    } on DioException catch (e) {
      // In case of error, set the state with the error message
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      // In case of any other error, set the state with the error string
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
