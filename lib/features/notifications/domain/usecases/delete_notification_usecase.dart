// import 'package:alfa_dashboard/core/networking/firebase_error_handler.dart';
// import 'package:alfa_dashboard/core/usecase/use_case.dart';
// import 'package:alfa_dashboard/features/notifications/domain/repository/transaction_repository.dart';
// import 'package:dartz/dartz.dart';
//
// class DeleteNotificationUseCase implements UseCasesWithFireBase<Unit, String> {
//   final NotificationRepository repo;
//
//   DeleteNotificationUseCase(this.repo);
//
//   @override
//   Future<Either<FirebaseFailure, Unit>> call(String notificationId) async {
//     return await repo.deleteNotification(notificationId);
//   }
// }