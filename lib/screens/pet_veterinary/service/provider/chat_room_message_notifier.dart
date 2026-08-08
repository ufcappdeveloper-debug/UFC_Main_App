// import 'dart:async';
// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ufc_mobile/screens/pet_veterinary/service/chat_service.dart';
// import 'package:ufc_mobile/screens/pet_veterinary/service/chat_socket_manager.dart';
// import 'package:ufc_mobile/screens/pet_veterinary/service/model/chat_message.dart';
// import 'package:ufc_mobile/util/dio/dio_intrepters.dart';

// final chatRoomMessagesProvider = StateNotifierProvider<ChatRoomMessagesNotifier,
//     AsyncValue<List<ChatMessage>>>(
//   (ref) => ChatRoomMessagesNotifier(),
// );

// class ChatRoomMessagesNotifier
//     extends StateNotifier<AsyncValue<List<ChatMessage>>> {
//   ChatRoomMessagesNotifier() : super(const AsyncValue.data([])) {
//     _subscription =
//         ChatSocketManager.chatStream.listen(_handleIncomingSocketMessage);
//   }

//   late final StreamSubscription _subscription;

//   void _handleIncomingSocketMessage(dynamic data) {
//     final newMessage = ChatMessage.fromJson(data);
//     final currentMessages = state.value ?? [];
//     state = AsyncValue.data([...currentMessages, newMessage]);
//   }

//   Future<void> sendMessage(Map<String, dynamic> json) async {
//     ChatSocketManager.emit("sendMessage", json);
//   }

//   Future<void> joinRoom(String roomId) async {
//     ChatSocketManager.joinRoom(roomId);
//   }

//   Future<void> fetchMessages({
//     required String roomId,
//     int page = 1,
//     int pageSize = 20,
//   }) async {
//     state = const AsyncValue.loading();
//     try {
//       final messages = await ChatService().getMessages(
//         roomId: roomId,
//         page: page,
//         pageSize: pageSize,
//       );
//       state = AsyncValue.data(messages);
//     } on DioException catch (e) {
//       state = AsyncValue.error(e.dioMessage, StackTrace.current);
//     } catch (e) {
//       log('ChatRoomMessages Error: $e');
//       state = AsyncValue.error(e.toString(), StackTrace.current);
//     }
//   }

//   Future<void> leaveRoom(String roomId) async {
//     ChatSocketManager.leaveRoom(roomId);
//   }

//   void addMessage(ChatMessage message) {
//     final currentMessages = state.value ?? [];
//     state = AsyncValue.data([...currentMessages, message]);
//   }

//   void addMessages(List<ChatMessage> messages) {
//     final currentMessages = state.value ?? [];
//     state = AsyncValue.data([...currentMessages, ...messages]);
//   }

//   void clearMessages() {
//     state = const AsyncValue.data([]);
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/chat_service.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/chat_socket_manager.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/chat_message.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';

final chatRoomMessagesProvider = StateNotifierProvider<ChatRoomMessagesNotifier,
    AsyncValue<List<ChatMessage>>>(
  (ref) => ChatRoomMessagesNotifier(),
);

class ChatRoomMessagesNotifier
    extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  ChatRoomMessagesNotifier() : super(const AsyncValue.data([])) {
    _subscription =
        ChatSocketManager.chatStream.listen(_handleIncomingSocketMessage);
  }

  late final StreamSubscription _subscription;

  int currentPage = 1;
  bool hasMore = true;
  bool isLoading = false;
  String? _roomId;

  String? _findSenderProfile(List<ChatMessage> messages, String senderId) {
    try {
      return messages
          .firstWhere(
            (e) => e.senderId == senderId && e.senderProfilePicture != null,
          )
          .senderProfilePicture;
    } catch (_) {
      return null;
    }
  }

  String? _findReceiverProfile(List<ChatMessage> messages, String receiverId) {
    try {
      return messages
          .firstWhere(
            (e) =>
                e.receiverId == receiverId && e.receiverProfilePicture != null,
          )
          .receiverProfilePicture;
    } catch (_) {
      return null;
    }
  }

  void _handleIncomingSocketMessage(dynamic data) {
    final newMessage = ChatMessage.fromJson(data);
    final currentMessages = state.value ?? [];

    final existingSenderPic =
        _findSenderProfile(currentMessages, newMessage.senderId);
    final existingReceiverPic =
        _findReceiverProfile(currentMessages, newMessage.receiverId);

    final updatedMessage = ChatMessage(
      id: newMessage.id,
      text: newMessage.text,
      senderId: newMessage.senderId,
      receiverId: newMessage.receiverId,
      messageType: newMessage.messageType,
      mediaType: newMessage.mediaType,
      mediaUrl: newMessage.mediaUrl,
      room: newMessage.room,
      createdAt: newMessage.createdAt,
      updatedAt: newMessage.updatedAt,
      senderProfilePicture:
          newMessage.senderProfilePicture ?? existingSenderPic,
      receiverProfilePicture:
          newMessage.receiverProfilePicture ?? existingReceiverPic,
      isDoctorSender: newMessage.isDoctorSender,
    );

    state = AsyncValue.data([...currentMessages, updatedMessage]);
  }

  Future<void> sendMessage(Map<String, dynamic> json) async {
    ChatSocketManager.emit("sendMessage", json);
  }

  Future<void> joinRoom(String roomId, String userId) async {
    _roomId = roomId;
    currentPage = 1;
    hasMore = true;
    clearMessages();
    await fetchMessages();
    ChatSocketManager.joinRoom(roomId, userId);
  }

  Future<void> fetchMessages({
    int pageSize = 10,
  }) async {
    if (isLoading || !hasMore || _roomId == null) return;

    final isInitialFetch = currentPage == 1 && (state.value?.isEmpty ?? true);
    if (isInitialFetch) {
      state = const AsyncValue.loading();
    } else {
      state = AsyncValue.data(List.from(state.value ?? []));
    }

    isLoading = true;

    try {
      final result = await ChatService().getMessages(
        roomId: _roomId!,
        page: currentPage,
        pageSize: pageSize,
      );

      final currentMessages = state.value ?? [];
      // state = AsyncValue.data([...currentMessages, ...result.messages]);
      state = AsyncValue.data([...result.messages, ...currentMessages]);

      final totalPages = result.pagination.totalPages;
      hasMore = currentPage < totalPages;
      currentPage += 1;
    } on DioException catch (e) {
      state = AsyncValue.error(e.dioMessage, StackTrace.current);
    } catch (e) {
      log('ChatRoomMessages Error: $e');
      state = AsyncValue.error(e.toString(), StackTrace.current);
    } finally {
      isLoading = false;
      state = AsyncValue.data(List.from(state.value ?? []));
    }
  }

  Future<void> leaveRoom(String roomId, String userId) async {
    ChatSocketManager.leaveRoom(roomId, userId);
    clearMessages();
    _roomId = null;
    currentPage = 1;
    hasMore = true;
  }

  void addMessage(ChatMessage message) {
    final currentMessages = state.value ?? [];
    state = AsyncValue.data([...currentMessages, message]);
  }

  void addMessages(List<ChatMessage> messages) {
    final currentMessages = state.value ?? [];
    state = AsyncValue.data([...currentMessages, ...messages]);
  }

  void clearMessages() {
    state = const AsyncValue.data([]);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
