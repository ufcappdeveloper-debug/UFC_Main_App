import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_chat_model.dart';
import 'package:ufc_mobile/models/community_models/channel_model/channel_list_model.dart';
import 'package:ufc_mobile/models/community_models/chat_model/upload_file_res_model.dart';
import 'package:ufc_mobile/models/community_models/group_model/group_list_res_model.dart';
import 'package:ufc_mobile/models/community_models/rules/community_rules_resp_model.dart';

class CommunityService {
  Future<GroupListResponseModel> getGroups({int page = 1}) async {
    final Response response =
        await api.get('/api/ufc/v1/community/group/get', queryParameters: {
      "page": page,
      "limit": 20,
    });

    return GroupListResponseModel.fromJson(response.data);
  }

  Future<CommunityRulesResponseModel> getRules({int page = 1}) async {
    final Response response =
        await api.get('api/ufc/v1/community/rules/get', queryParameters: {
      "page": page,
      "limit": 20,
    });

    debugPrint('response.data=> ${response.data}');
    return CommunityRulesResponseModel.fromJson(response.data);
  }

  Future<ChannelListResponseModel> getChannels({
    int page = 1,
    String? searchValue,
  }) async {
    final Response response =
        await api.get('/api/ufc/v1/community/channel/get', queryParameters: {
      "page": page,
      "limit": 20,
      if ((searchValue ?? '').isNotEmpty) 'search': searchValue
    });
    return ChannelListResponseModel.fromJson(response.data);
  }

  Future<List<CommunityChatModel>?> getChats(
      Map<String, dynamic> data, int id) async {
    final Response response = await api.get(
        '/api/ufc/v1/community/message/get-messages/$id',
        queryParameters: data);
    if (response.data['data'] is List && response.data['data'].isNotEmpty) {
      return (response.data['data'] as List<dynamic>)
          .map((e) => CommunityChatModel.fromJson(e))
          .toList();
    }
    return null;
  }

  Future<bool> sendMessage(FormData data) async {
    final Response response = await api
        .post('/api/ufc/v1/community/message/send-message', data: data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> editMessage(FormData data) async {
    try {
      debugPrint("DATA -- ${data.fields}");
      final Response response = await api
          .post('/api/ufc/v1/community/message/edit-message', data: data);
      debugPrint("RESPONSE -- ${response.data}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteMessage(int id) async {
    final Response response =
        await api.delete('/api/ufc/v1/community/message/delete-message/$id');
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> reportMessage(FormData data) async {
    final Response response = await api
        .post('/api/ufc/v1/community/message/report-message', data: data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<UploadedFileModel?> uploadDocuments(FormData data) async {
    try {
      final Response response = await api
          .post('api/ufc/v1/community/message/upload-attachment', data: data);

      final fileResponse = UploadFileResponseModel.fromJson(response.data);
      if (fileResponse.status?.toLowerCase().trim() == 'success') {
        return fileResponse.fileModel;
      }

      return null;
    } on DioException catch (e) {
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
