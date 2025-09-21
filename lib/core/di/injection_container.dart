import 'package:alfa_dashboard/core/services/notifications/notification_service.dart';
import 'package:alfa_dashboard/features/notifications/data/data_sources/notification_remote_data_source_impl.dart';
import 'package:alfa_dashboard/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:alfa_dashboard/features/notifications/data/repository/notification_repository_impl.dart';
import 'package:alfa_dashboard/features/notifications/domain/repository/notification_repo.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/add_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/fetch_all_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/fetch_user_notifications_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/send_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:alfa_dashboard/features/transaction/data/data_sources/transactions_remote_data_source.dart';
import 'package:alfa_dashboard/features/transaction/data/repository/transaction_repo_imp.dart';
import 'package:alfa_dashboard/features/transaction/domain/repository/transaction_repository.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_all_transaction_usecase.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_all_transactions_stream_usecase.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_user_transaction_usecase.dart';
import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:alfa_dashboard/features/user/data/repositories/user_repo_imp.dart';
import 'package:alfa_dashboard/features/user/domain/repositories/user_repo.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/delete_user_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_all_users_stream_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_all_users_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_user_data_usecse.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/update_user_balance_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/update_user_data_usecase.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/withdraw_requests/data/data_sources/withdraw_remote_data_source.dart';
import 'package:alfa_dashboard/features/withdraw_requests/data/repository/withdraw_repo_imp.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/repository/withdraw_repository.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/usecases/fetch_all_withdraws_usecase.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/usecases/get_eithdraw_requests_stream_usecase.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/usecases/update_withdraw_request_status_usecase.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/manager/withdraw_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //TODO: External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  //TODO: Firestore data source
  sl.registerLazySingleton<AuthFireStoreDataSource>(
        () => AuthFireStoreDataSourceImpl(sl()),
  );

 sl.registerLazySingleton<NotificationService>(() => NotificationService(),
  );


  //TODO: Remote data source

  sl.registerLazySingleton<TransactionsRemoteDataSource>(
        () => TransactionsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<WithdrawRequestsRemoteDataSource>(
        () => WithdrawRequestsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<NotificationRemoteDataSource>(
        () =>  NotificationRemoteDataSourceImpl(sl()),
  );


  //TODO: Repository

  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImp(sl()),
  );

  sl.registerLazySingleton<TransactionRepository>(
        () => TransactionRepoImpl(sl()),
  );

  sl.registerLazySingleton<WithdrawRepository>(
        () => WithdrawRepoImpl(sl()),
  );

  sl.registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImpl(sl()),
  );

  //TODO: Use cases
  // sl.registerLazySingleton(() => SignInUseCase(sl()));
  // sl.registerLazySingleton(() => SignUpUseCase(sl()));
  // sl.registerLazySingleton(() => SignOutUseCase(sl()));
  // sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  // sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => FetchUserDataUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserDataUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllUSersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserBalanceUseCase(sl()));
  sl.registerLazySingleton(() => FetchUserTransactionUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllTransactionUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllWithdrawsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWithdrawRequestStatusUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTransactionUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllUSersStreamUseCase(sl()));
  sl.registerLazySingleton(() => AddNotificationUseCase(sl()));
  sl.registerLazySingleton(() => SendNotificationUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationAsReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsAsReadUseCase(sl()));
  sl.registerLazySingleton(() => FetchUserNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => GetWithdrawRequestsStreamUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllTransactionsStreamUseCase(sl()));


  //TODO: Cubits
  sl.registerFactory(() => UserCubit(
    fetchUserDataUseCase: sl(),
    updateUserUseCase: sl(),
    fetchAllUSersUseCase: sl(),
    updateUserBalanceUseCase: sl(),
    deleteUserUseCase: sl(),
    fetchAllUSersStreamUseCase: sl(),
  ));

  sl.registerFactory(() => TransactionCubit(
    fetchUserTransactionUseCase: sl(),
    fetchAllTransactionsUseCase: sl(),
    deleteTransactionUseCase: sl(),
    fetchAllTransactionsStreamUseCase: sl(),
  ));

  sl.registerFactory(() => WithdrawRequestsCubit(
    fetchAllWithdrawsUseCase: sl(),
    updateWithdrawRequestStatusUseCase: sl(),
    userCubit: sl(),
    notificationService: sl(),
    sendNotificationUseCase: sl(),
    getWithdrawRequestsStreamUseCase: sl(),
  ));

  sl.registerFactory(() => NotificationCubit(
    fetchUserNotificationsUseCase: sl(),
    fetchAllNotificationsUseCase: sl(),
    markNotificationAsReadUseCase: sl(),
    markAllNotificationsAsReadUseCase: sl(),
    addNotificationUseCase: sl(),
    sendNotificationUseCase: sl(),
  ));
}
