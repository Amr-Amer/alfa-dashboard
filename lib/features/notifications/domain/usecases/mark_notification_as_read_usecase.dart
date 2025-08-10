import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/notifications/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';

class MarkNotificationAsReadParams {
  final String uid;
  final String notificationId;

  MarkNotificationAsReadParams({required this.uid, required this.notificationId});
}

class MarkNotificationAsReadUseCase implements UseCases<void, MarkNotificationAsReadParams> {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  @override
  Future<Either<ErrorModel, void>> call(MarkNotificationAsReadParams params) {
    return repository.markNotificationAsRead(params.uid, params.notificationId);
  }
}
