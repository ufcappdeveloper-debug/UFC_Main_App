

import '../entities/notification/feed_notification_model.dart';
import '../entities/notification/notification_query_model.dart';

abstract class NotificationRepository {
  Future<List<FeedNotificationModel>> getUserNotifications(NotificationQueryParams params);
}
