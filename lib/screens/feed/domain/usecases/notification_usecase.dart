import '../entities/notification/feed_notification_model.dart';
import '../entities/notification/notification_query_model.dart';
import '../repositories/notification_repo.dart';

class GetUserNotificationsUseCase {
  final NotificationRepository repository;
  GetUserNotificationsUseCase(this.repository);

  Future<List<FeedNotificationModel>> call(NotificationQueryParams params) {
    return repository.getUserNotifications(params);
  }
}
