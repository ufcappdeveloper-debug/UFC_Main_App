import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/community_service.dart';

part 'chat_send_edit_riverpod.g.dart';

@Riverpod(keepAlive: true)
class ChatSendEditRiverpod extends _$ChatSendEditRiverpod {
  @override
  FutureOr<bool> build() => true;

  Future<void> sendMessage(FormData data) async {
    state = const AsyncValue.loading();
    try {
      debugPrint("FORMDATA -- ${data.fields}");
      final bool result = await CommunityService().sendMessage(data);
      if (result) {
        state = AsyncValue.data(true);
      } else {
        state = AsyncValue.error('failed', StackTrace.current);
      }
    } on DioException catch (e) {
      debugPrint("ERROR -- $e");
      state = AsyncValue.error(e.error.toString(), StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> editMessage(FormData data) async {
    state = const AsyncValue.loading();
    try {
      await CommunityService().editMessage(data);
      state = AsyncValue.data(true);
    } catch (e) {
      state = AsyncValue.data(true);
    }
  }

  Future<void> deleteMessage(int messageId) async {
    try {
      await CommunityService().deleteMessage(messageId);
      state = AsyncValue.data(true);
    } catch (e) {
      state = AsyncValue.data(true);
    }
  }

  Future<void> reportMessae(FormData data) async {
    state = const AsyncValue.loading();
    try {
      final bool result = await CommunityService().reportMessage(data);
      if (result) {
        state = AsyncValue.data(true);
      } else {
        state = AsyncValue.error('failed', StackTrace.current);
      }
    } on DioException catch (e) {
      debugPrint("ERROR -- $e");
      state = AsyncValue.error(e.error.toString(), StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}
