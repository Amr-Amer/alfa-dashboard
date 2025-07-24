import 'package:alfa_dashboard/features/transaction/data/data_sources/transactions_remote_data_source.dart';
import 'package:alfa_dashboard/features/transaction/data/repository/transaction_repo_imp.dart';
import 'package:alfa_dashboard/features/transaction/domain/repository/transaction_repository.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_all_transaction_usecase.dart';
import 'package:alfa_dashboard/features/transaction/domain/usecases/fetch_user_transaction_usecase.dart';
import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:alfa_dashboard/features/user/data/repositories/user_repo_imp.dart';
import 'package:alfa_dashboard/features/user/domain/repositories/user_repo.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_all_users_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_user_data_usecse.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/update_user_data_usecase.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //TODO: External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  //TODO: Firestore data source
  sl.registerLazySingleton<AuthFireStoreDataSource>(
        () => AuthFireStoreDataSourceImpl(sl()),
  );


  //TODO: Remote data source
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //       () => AuthRemoteDataSourceImpl(sl(), sl()),
  // );

  sl.registerLazySingleton<TransactionsRemoteDataSource>(
        () => TransactionsRemoteDataSourceImpl(sl()),
  );

  // sl.registerLazySingleton<BalanceRemoteDataSource>(
  //       () => BalanceRemoteDataSourceImpl(firestore: sl()),
  // );


  //TODO: Repository
  // sl.registerLazySingleton<AuthRepository>(
  //       () => AuthRepositoryImpl(sl()),
  // );
  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImp(sl()),
  );

  sl.registerLazySingleton<TransactionRepository>(
        () => TransactionRepoImpl(sl()),
  );

  // sl.registerLazySingleton<BalanceRepository>(
  //       () => BalanceRepoImpl(sl()),
  // );

  //TODO: Use cases
  // sl.registerLazySingleton(() => SignInUseCase(sl()));
  // sl.registerLazySingleton(() => SignUpUseCase(sl()));
  // sl.registerLazySingleton(() => SignOutUseCase(sl()));
  // sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  // sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => FetchUserDataUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserDataUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllUSersUseCase(sl()));
  sl.registerLazySingleton(() => FetchUserTransactionUseCase(sl()));
  sl.registerLazySingleton(() => FetchAllTransactionUseCase(sl()));

  // sl.registerLazySingleton(() => CreateWithdrawRequestUseCase(sl()));

  // Cubit
  // sl.registerFactory(() => AuthCubit(
  //   signInUseCase: sl(),
  //   signUpUseCase: sl(),
  //   signOutUseCase: sl(),
  //   resetPasswordUseCase: sl(),
  //   getCurrentUserUseCase: sl(),
  // ));

  sl.registerFactory(() => UserCubit(
    fetchUserDataUseCase: sl(),
    updateUserUseCase: sl(),
    fetchAllUSersUseCase: sl(),
  ));

  sl.registerFactory(() => TransactionCubit(
    fetchUserTransactionUseCase: sl(),
    fetchAllTransactionsUseCase: sl(),
  ));

  // sl.registerFactory(() => BalanceCubit(
  //   createTransactionUseCase: sl(),
  //   userCubit: sl(),
  // ));

}
