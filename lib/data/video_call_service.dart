import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/video/video_call.dart';

class VideoCallService {
  static Future<VideoCallTokenResponse> getToken(
      {required String userId, required String channelName}) async {
    Response response = await api.get(
      "api/ufc/v1/get_agora_token?channel_name=$channelName&user_id=$userId",
    );
    return VideoCallTokenResponse.fromJson(response.data ?? {});
  }
}
