import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';

class FetchUserNotificationsUseCase implements UseCases<List<NotificationModel>, String> {
  final NotificationRepository repository;

  FetchUserNotificationsUseCase(this.repository);

  @override
  Future<Either<ErrorModel, List<NotificationModel>>> call(String uid) {
    return repository.fetchUserNotifications(uid);
  }
}
