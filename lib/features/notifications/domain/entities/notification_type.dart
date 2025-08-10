enum NotificationType {
  income,
  expense,
  transfer,
  payment,
  receipt,
  loan,
  withdraw
}

extension NotificationTypeExt on NotificationType {
  String get name => toString().split('.').last;
  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => NotificationType.income,
    );
  }
}