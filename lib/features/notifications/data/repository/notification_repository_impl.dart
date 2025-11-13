import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ErrorModel, void>> sendNotification(NotificationModel notification) {
    return remoteDataSource.sendNotification(notification);
  }

  @override
  Future<Either<ErrorModel, void>> addNotification(NotificationModel notification) {
    return remoteDataSource.addNotification(notification);
  }
}
