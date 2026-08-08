import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:ufc_mobile/global/config/dio.dart';
import 'package:ufc_mobile/models/notification_model.dart';
import 'package:ufc_mobile/models/params/send_notification_param.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/chat_service.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotifications(final data) async {
    Response response =
        await api.get("api/ufc/v1/get_user_notifications", data: data);
    return (response.data["data"]["data"] as List<dynamic>)
        .map((data) => NotificationModel.fromJson(data))
        .toList();
  }

  Future<List<String>> getNotificationCategories() async {
    Response response = await api.get(
      "api/ufc/v1/get_notification_categories",
    );
    return [
      ...(response.data["data"] as List<dynamic>).where((data) => data != null)
    ];
  }

  Future<void> sendNotificationtoDoctor({
    required SendNotificationParam param,
  }) async {
    try {
      debugPrint("Sending notification with params: ${param.toJson()}");

      Response response = await ChatDio.api.post(
        "/api/v1/notification/send",
        data: param.toJson(),
      );

      debugPrint("Notification API Response Status: ${response.statusCode}");
      debugPrint("Notification API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        debugPrint("✅ Notification successfully sent to doctor");
      } else {
        debugPrint(
            "⚠️ Failed to send notification. Status: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error sending notification: $e");
      debugPrint("StackTrace: $stackTrace");
    }
  }
}
