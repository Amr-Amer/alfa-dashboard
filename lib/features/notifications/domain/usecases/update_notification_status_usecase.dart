// import 'package:alfa_dashboard/core/networking/firebase_error_handler.dart';
// import 'package:alfa_dashboard/core/usecase/use_case.dart';
// import 'package:alfa_dashboard/features/notifications/domain/repository/notification_repo.dart';
// import 'package:dartz/dartz.dart';
//
// class UpdateParams {
//   final String notificationId;
//   final bool notificationStatus;
//   UpdateParams({required this.notificationId, required this.notificationStatus});
// }
//
// class UpdateNotificationStatusUseCase implements UseCasesWithFireBase<Unit, UpdateParams> {
//   final NotificationRepository repo;
//
//   UpdateNotificationStatusUseCase(this.repo);
//
//   @override
//   Future<Either<FirebaseFailure, Unit>> call(UpdateParams params) async {
//     return await repo.updateTransactionStatus(params.notificationId, params.notificationStatus);
//   }
// }