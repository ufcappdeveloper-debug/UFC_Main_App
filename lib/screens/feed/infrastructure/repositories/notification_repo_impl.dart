

import '../../domain/entities/notification/feed_notification_model.dart';
import '../../domain/entities/notification/notification_query_model.dart';
import '../../domain/repositories/notification_repo.dart';
import '../data_sources/notification_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FeedNotificationModel>> getUserNotifications(NotificationQueryParams params) {
    return remoteDataSource.getUserNotifications(params);
  }
}
