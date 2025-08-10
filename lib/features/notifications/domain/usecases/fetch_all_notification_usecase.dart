import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';

class FetchAllNotificationsUseCase implements UseCasesNoParams<List<NotificationModel>> {
  final NotificationRepository repo;

  FetchAllNotificationsUseCase(this.repo);

  @override
  Future<Either<ErrorModel, List<NotificationModel>>> call() {
    return repo.fetchAllNotifications();
  }
}
