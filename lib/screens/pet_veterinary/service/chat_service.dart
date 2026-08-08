import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ufc_mobile/global/config/config.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/global/util/dio/dio_intrepters.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/chat_message.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/chat_preview_message.dart';

class ChatDio {
  static final Dio _chatDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.chatBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(AppInterceptor());

  static Dio get api => _chatDio;
}

class ChatService {
  Future<ChatPaginatedMessages> getMessages({
    required String roomId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await ChatDio.api.get(
        '/api/v1/messages',
        queryParameters: {
          'room': roomId,
          'page': page,
          'pageSize': pageSize,
        },
      );

      final data = response.data;
      if (response.statusCode == 200) {
        return ChatPaginatedMessages.fromJson(data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: "Failed to fetch messages",
      );
    } catch (e) {
      throw e is DioException
          ? e
          : DioException(
              requestOptions: RequestOptions(path: '/api/v1/messages'),
              type: DioExceptionType.unknown,
              error: e.toString(),
            );
    }
  }

  Future<ListResponse<ChatPreviewMessage>> getMessagesListForUser(
      {int page = 1, String search = ""}) async {
    final response =
        await ChatDio.api.get('/api/v1/messages/list', queryParameters: {
      'page': page,
      if (search.isNotEmpty) 'search': search,
    });

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final List<dynamic> dataList = response.data['data'];
      final pagination = response.data['pagination'];
      final messages =
          dataList.map((json) => ChatPreviewMessage.fromJson(json)).toList();

      return ListResponse(
        data: messages,
        currentPage: pagination['page'] ?? 1,
        totalPages: pagination['totalPages'] ?? 1,
        hasMore: pagination['hasMore'] ?? false,
      );
    } else {
      throw Exception("Failed to fetch user messages list");
    }
  }

  Future<String> uploadMedia(File file) async {
    debugPrint("Uploading file: ${file.path}");

    final formData = FormData.fromMap({
      "media": await MultipartFile.fromFile(file.path),
    });

    try {
      final response = await api.post(
        "/api/ufc/v1/upload_file",
        data: formData,
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Data: ${response.data}");

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data;
        if (data is Map<String, dynamic> && data["url"] != null) {
          return data["url"];
        } else {
          throw Exception("Missing 'url' in response");
        }
      } else {
        throw Exception(
          "Upload failed [${response.statusCode}]: ${response.statusMessage}",
        );
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      rethrow;
    }
  }
}
