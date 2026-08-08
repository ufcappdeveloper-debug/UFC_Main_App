import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/data/community_service.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_chat_model.dart';

part 'chat_riverpod.g.dart';

@Riverpod(keepAlive: true)
class ChatRiverpod extends _$ChatRiverpod {
  @override
  FutureOr<List<CommunityChatModel>?> build() => null;

  Future<void> fetchChats(int id) async {
    state = const AsyncValue.loading();
    try {
      final Map<String, dynamic> data = {'page': 1, 'limit': 20};
      final List<CommunityChatModel>? chats =
          await CommunityService().getChats(data, id);
      if (chats != null) {
        state = AsyncValue.data(chats);
      } else {
        state = AsyncValue.error('No chats available', StackTrace.current);
      }
    } on DioException catch (e) {
      debugPrint("RESPONSE -- ${e.toString()}");
      state = AsyncValue.error(e.toString(), StackTrace.current);
      rethrow;
    } catch (e, st) {
      debugPrint("RESPONSE -- ${e.toString()}");
      state = AsyncValue.error(e.toString(), st);
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  Future<void> loadChats(int page, int id) async {
    state = const AsyncValue.loading();
    try {
      final Map<String, dynamic> data = {'page': page, 'limit': 20};
      final List<CommunityChatModel>? chats =
          await CommunityService().getChats(data, id);
      final current = state.value;

      if (current == null) {
        state = AsyncValue.data(chats);
      } else {
        final List<CommunityChatModel> allChats = [...current, ...chats ?? []];
        state = AsyncValue.data(allChats);
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}
