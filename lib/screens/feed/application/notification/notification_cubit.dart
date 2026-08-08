import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/notification/feed_notification_model.dart';
import '../../domain/entities/notification/notification_query_model.dart';
import '../../domain/usecases/notification_usecase.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetUserNotificationsUseCase getUserNotificationsUseCase;

  NotificationCubit(this.getUserNotificationsUseCase)
      : super(NotificationInitial());

  List<FeedNotificationModel> allNotifications = [];
  int currentPage = 1;
  bool isLastPage = false;
  bool isLoadingMore = false;

  Future<void> fetchNotifications({int limit = 10}) async {
    if (isLoadingMore || isLastPage) return;

    isLoadingMore = true;

    // Only show full-page loader on first page
    if (currentPage == 1) emit(NotificationLoading());

    try {
      final notifications = await getUserNotificationsUseCase(
        NotificationQueryParams(page: currentPage, limit: limit),
      );

      // ✅ Mark last page if API returns < limit
      if (notifications.length < limit) {
        isLastPage = true;
      }

      if (notifications.isNotEmpty) {
        allNotifications.addAll(notifications);
        currentPage++;
        emit(NotificationLoaded(List.from(allNotifications))); // copy for rebuild
      } else {
        emit(NotificationLoaded(List.from(allNotifications))); // still emit to stop spinner
      }
    } catch (e) {
      emit(NotificationError(e));
    } finally {
      isLoadingMore = false;
    }
  }


  void resetNotifications() {
    allNotifications.clear();
    currentPage = 1;
    isLastPage = false;
    emit(NotificationInitial());
  }
}



