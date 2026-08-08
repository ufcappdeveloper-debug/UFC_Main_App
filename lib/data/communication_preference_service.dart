import 'package:dio/dio.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';

import '../global/config/dio.dart';

class CommunicationPreferenceService {
  Future<UserModel> updatePreference(final preferences) async {
    Response response =
        await api.post("api/ufc/v1/update_notification", data: preferences);
    return UserModel.fromJson(response.data["user"]);
  }
}
