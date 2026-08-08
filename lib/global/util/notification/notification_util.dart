import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/notification/feed_notification_model.dart';

class NotificationUtil {
  static String notificationName(FeedNotificationModel? notification) {
    if (isArabic) {
      return notification?.titleAr ?? notification?.title ?? notification?.titleUr ?? '';
    } else if (isUrdu) {
      return notification?.titleUr ?? notification?.title ?? notification?.titleAr ?? '';
    } else {
      return notification?.title ?? notification?.titleAr ?? notification?.titleUr ?? '';
    }
  }

  static String notificationDescription(FeedNotificationModel? notification) {
    if (isArabic) {
      return notification?.descriptionAr ?? notification?.description ?? notification?.descriptionUr ?? '';
    } else if (isUrdu) {
      return notification?.descriptionUr ?? notification?.description ?? notification?.descriptionAr ?? '';
    } else {
      return notification?.description ?? notification?.descriptionAr ?? notification?.descriptionUr ?? '';
    }
  }
}

