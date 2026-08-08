import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/sadad_service.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/checkout/sadad/sadad_user_info.dart';

part "sadad_user_async_riverpod.g.dart";

@Riverpod(keepAlive: true)
class SadadUserAsync extends _$SadadUserAsync {
  @override
  FutureOr<SadadUserInfo?> build() async {
    return null;
  }

  Future<void> getSadadUserInfo() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await SadadService().getSadadUserInfo());
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> updateSadadUserInfo(final data) async {
    try {
      state = AsyncValue.data(await SadadService().updateSadadUserInfo(data));
    } on DioException catch (e) {
      throw e.dioMessage;
    } catch (e) {
      throw e.toString();
    }
  }
}
