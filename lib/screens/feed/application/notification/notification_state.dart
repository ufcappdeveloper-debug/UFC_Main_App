import 'package:equatable/equatable.dart';

import '../../domain/entities/notification/feed_notification_model.dart';


abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationLoaded extends NotificationState {
  final List<FeedNotificationModel> notifications;
  const NotificationLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}
class NotificationError extends NotificationState {
  final Object message;
  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
