import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';

class AddNotificationUseCase implements UseCases<void, NotificationModel> {
  final NotificationRepository repo;

  AddNotificationUseCase(this.repo);

  @override
  Future<Either<ErrorModel, void>> call( NotificationModel notification) {
    return repo.addNotification(notification);
  }
}
