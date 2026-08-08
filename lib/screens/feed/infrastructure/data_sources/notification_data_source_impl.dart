

import 'package:dio/dio.dart';
import 'package:ufc_mobile/global/config/dio.dart';

import '../../../../global/config/config.dart';
import '../../domain/entities/notification/feed_notification_model.dart';
import '../../domain/entities/notification/notification_query_model.dart';
import 'notification_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;
  NotificationRemoteDataSourceImpl(this.dio);

  @override
  Future<List<FeedNotificationModel>> getUserNotifications(
      NotificationQueryParams params) async {
    print("Fetching notifications with params: ${params.toJson()}");

    final response = await api.get(
      "/api/ufc/v1/get_user_notifications",
      queryParameters: params.toJson(),
      options: Options(headers: {
        "Authorization": "Bearer ${AppConfig.token}",
      }),
    );

    print("Raw response data not: ${response.data}");

    final data = response.data['data']['data'] as List;
    print("Parsed notifications list length: ${data.length}");

    final notifications =
    data.map((json) => FeedNotificationModel.fromJson(json)).toList();

    print("Notifications parsed successfully: $notifications");

    return notifications;
  }
}
