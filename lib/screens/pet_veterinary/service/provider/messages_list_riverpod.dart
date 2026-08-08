import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/chat_service.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/chat_preview_message.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/chat_list_screen.dart';

part 'messages_list_riverpod.g.dart';

@Riverpod(keepAlive: true)
class MessagesListForUser extends _$MessagesListForUser {
  List<ChatPreviewMessage> _allMessages = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetching = false;
  String _searchQuery = "";

  @override
  FutureOr<List<ChatPreviewMessage>> build() async {
    await fetchMessagesList(reset: true);
    return _allMessages;
  }

  Future<void> fetchMessagesList({bool reset = false, String? search}) async {
    if (_isFetching) return;

    final isLoadingNotifier = ref.read(isLoadingMoreProvider.notifier);

    if (search != null) {
      if (search.trim().isEmpty) {
        _searchQuery = "";
      } else if (search != _searchQuery) {
        _searchQuery = search;
      }
      reset = true;
    }
    if (reset) {
      _currentPage = 1;
      _allMessages = [];
    } else if (_currentPage > _totalPages) {
      return;
    }

    _isFetching = true;
    if (!reset) {
      isLoadingNotifier.state = true;
    } else {
      state = const AsyncValue.loading();
    }

    try {
      final response = await ChatService()
          .getMessagesListForUser(page: _currentPage, search: _searchQuery);

      _totalPages = response.totalPages;
      _allMessages.addAll(response.data);

      state = AsyncValue.data(_allMessages);
      _currentPage++;
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log('MessagesList Error: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
    } finally {
      _isFetching = false;
      isLoadingNotifier.state = false;
    }
  }
}
