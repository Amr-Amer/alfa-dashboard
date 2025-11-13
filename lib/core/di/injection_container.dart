import 'package:alfa_dashboard/core/services/notifications/notification_service.dart';
import 'package:alfa_dashboard/features/notifications/data/data_sources/notification_remote_data_source_impl.dart';
import 'package:alfa_dashboard/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:alfa_dashboard/features/notifications/data/repository/notification_repository_impl.dart';
import 'package:alfa_dashboard/features/notifications/domain/repository/notification_repo.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/add_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/send_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/data/data_sources/deposit_remote_data_source.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/data/repository/deposits_repo_imp.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/domain/repository/deposits_repository.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/domain/usecases/fetch_deposits_stream_usecase.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/domain/usecases/update_deposits_status_usecase.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/presentation/manager/deposits_cubit.dart';
import 'package:alfa_dashboard/features/requests/top_up/data/data_sources/topup_remote_data_source.dart';
import 'package:alfa_dashboard/features/requests/top_up/data/repository/topup_repository_impl.dart';
import 'package:alfa_dashboard/features/requests/top_up/domain/repository/topup_repository.dart';
import 'package:alfa_dashboard/features/requests/top_up/domain/usecases/get_topup_usecase.dart';
import 'package:alfa_dashboard/features/requests/top_up/presentation/manager/requests_cubit.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/data/data_sources/withdraw_remote_data_source.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/data/repository/withdraws_repo_imp.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/domain/repository/withdraws_repository.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/domain/usecases/fetch_withdraws_stream_usecase.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/domain/usecases/update_withdraws_status_usecase.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/presentation/manager/withdraws_cubit.dart';
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
  sl.registerLazySingleton<AuthFireStoreDataSource>(() => AuthFireStoreDataSourceImpl(sl()),);
  sl.registerLazySingleton<NotificationService>(() => NotificationService(),);

  //TODO: Remote data source
  sl.registerLazySingleton<TransactionsRemoteDataSource>(() => TransactionsRemoteDataSourceImpl(sl()),);
  sl.registerLazySingleton<NotificationRemoteDataSource>(() =>NotificationRemoteDataSourceImpl(sl()),);
  sl.registerLazySingleton<TopUpRemoteDataSource>(() =>  TopUpRemoteDataSourceImpl(firestore: sl()),);
  sl.registerLazySingleton<WithdrawsRemoteDataSource>(() =>  WithdrawsRemoteDataSourceImpl(sl()),);
  sl.registerLazySingleton<DepositsRemoteDataSource>(() =>  DepositsRemoteDataSourceImpl(sl()),);

  //TODO: Repository
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImp(sl()),);
  sl.registerLazySingleton<TransactionRepository>(() => TransactionRepoImpl(sl()),);
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(sl()),);
  sl.registerLazySingleton<TopUpRepository>(() => TopUpRepositoryImpl(remoteDataSource: sl()),);
  sl.registerLazySingleton<WithdrawsRepository>(() => WithdrawsRepoImpl(sl()),);
  sl.registerLazySingleton<DepositsRepository>(() => DepositsRepoImpl(sl()),);

  //TODO: Use cases
  sl.registerLazySingleton(() => FetchUserDataUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserDataUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllUSersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserBalanceUseCase(sl()));
  sl.registerLazySingleton(() => FetchUserTransactionUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllTransactionUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTransactionUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllUSersStreamUseCase(sl()));
  sl.registerLazySingleton(() => AddNotificationUseCase(sl()));
  sl.registerLazySingleton(() => SendNotificationUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllTransactionsStreamUseCase(sl()));
  sl.registerLazySingleton(() => GetTopUpStreamUseCase(sl()));
  sl.registerLazySingleton(() => FetchWithdrawsStreamUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWithdrawsStatusUseCase(sl()));
  sl.registerLazySingleton(() => FetchDepositsStreamUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDepositsStatusUseCase(sl()));

  //TODO: Cubits
  sl.registerFactory(() => UserCubit(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => TransactionCubit(sl(),sl(),sl(),sl()));
  sl.registerFactory(() => RequestsCubit(sl(), sl(), sl(),sl(),));
  sl.registerFactory(() => WithdrawsCubit(sl(),sl(),sl(),sl()));
  sl.registerFactory(() => DepositsCubit(sl(),sl(),sl(),sl()));
  sl.registerFactory(() => NotificationCubit(sl(),sl()));
}
