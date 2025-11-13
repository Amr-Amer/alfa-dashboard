
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  String message;
  NotificationSuccess(this.message);
}

class NotificationUserSelected extends NotificationState {}

class NotificationAllUsersSelected extends NotificationState {}

class NotificationSentSuccessfully extends NotificationState {
  final String message;
  NotificationSentSuccessfully({required this.message});
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}


class NotificationUsersLoaded extends NotificationState {}

