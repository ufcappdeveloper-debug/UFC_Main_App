import '../../domain/entities/notification/feed_notification_model.dart';
import '../../domain/entities/notification/notification_query_model.dart';


abstract class NotificationRemoteDataSource {
  Future<List<FeedNotificationModel>> getUserNotifications(NotificationQueryParams params);
}


