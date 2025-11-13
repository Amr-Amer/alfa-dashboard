import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepository {
  Future<Either<ErrorModel, void>> sendNotification(NotificationModel notification);
  Future<Either<ErrorModel, void>> addNotification(NotificationModel notification);
}
