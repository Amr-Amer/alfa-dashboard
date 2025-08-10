import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/notifications/domain/repository/notification_repo.dart';
import 'package:dartz/dartz.dart';

class MarkAllNotificationsAsReadParams {
  final String uid;

  MarkAllNotificationsAsReadParams({required this.uid});
}

class MarkAllNotificationsAsReadUseCase implements UseCases<void, MarkAllNotificationsAsReadParams> {
  final NotificationRepository repository;

  MarkAllNotificationsAsReadUseCase(this.repository);

  @override
  Future<Either<ErrorModel, void>> call(MarkAllNotificationsAsReadParams params) {
    return repository.markAllAsRead(params.uid);
  }
}
