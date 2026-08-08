import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/banner_service.dart';
import 'package:ufc_mobile/models/banner_model.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

part 'banner_noti_riverpod.g.dart';

@Riverpod(keepAlive: true)
class BannerNotiRiverpod extends _$BannerNotiRiverpod {
  @override
  Future<BannerModel?> build() async {
    return null;
  }

  Future<void> getBannerNotification() async {
    state = const AsyncValue.loading();
    try {
      final BannerModel? result = await BannerService().getBannerNotification();
      state = AsyncValue.data(result);
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
