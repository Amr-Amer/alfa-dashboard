import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationsLoaded(this.notifications, [int? unreadCount])
      : unreadCount = unreadCount ?? notifications.where((n) => !n.read).length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NotificationsLoaded &&
              runtimeType == other.runtimeType &&
              unreadCount == other.unreadCount &&
              notifications.length == other.notifications.length;

  @override
  int get hashCode => unreadCount ^ notifications.length;
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
