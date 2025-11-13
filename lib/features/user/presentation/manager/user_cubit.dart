import 'dart:async';
import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/delete_user_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_all_users_stream_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_all_users_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_user_data_usecse.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/update_user_balance_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/update_user_data_usecase.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_state.dart';
import 'package:bloc/bloc.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserCubit extends Cubit<UserState> {
  final FetchUserDataUseCase fetchUserDataUseCase;
  final UpdateUserDataUseCase updateUserUseCase;
  final FetchAllUSersUseCase fetchAllUSersUseCase;
  final UpdateUserBalanceUseCase updateUserBalanceUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final FetchAllUSersStreamUseCase  fetchAllUSersStreamUseCase;
  UserCubit(
    this.fetchUserDataUseCase,
    this.updateUserUseCase,
    this.fetchAllUSersUseCase,
    this.updateUserBalanceUseCase,
    this.deleteUserUseCase,
    this.fetchAllUSersStreamUseCase
  ) : super(UserInitial()) {
    fetchAllUsersStream();
    // fetchUserData();
  }


  final TextEditingController balanceController = TextEditingController();
  StreamSubscription? _usersSubscription;

  void fetchAllUsersStream() {
    emit(UserLoading());
    _usersSubscription?.cancel();
    _usersSubscription = fetchAllUSersStreamUseCase().listen(
          (either) {
        either.fold(
              (failure) => emit(UserError(failure.message)),
              (userData) {
                usersList = userData;
            emit(AllUsersLoaded(users));
          },
        );
        if (kDebugMode) {
          print("user data.................... ${users.length}");
        }
      },
    );
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }

  // Future<void> fetchUserData() async {
  //   emit(UserLoading());
  //   final result = await fetchUserDataUseCase.call(NoParams());
  //
  //   result.fold(
  //         (error) => emit(UserError(error.message)),
  //         (userData) {
  //           userModel = userData;
  //       emit(UserLoaded(user!));
  //     },
  //   );
  //   if (kDebugMode) {
  //     print("user data.................... ");
  //     print(user);
  //   }
  // }

  //   Future<void> fetchAllUsers() async {
  //     emit(UserLoading());
  //     final result = await fetchAllUSersUseCase.call(NoParams());
  //
  //     result.fold(
  //           (error) => emit(UserError(error.message)),
  //           (userData) {
  //             usersList = userData;
  //         emit(AllUsersLoaded(userData));
  //       },
  //     );
  //     if (kDebugMode) {
  //       print("all users data.................... ");
  //       print(user);
  //     }
  //   }


  Future<void> updateUserBalance(double amount, String uid) async {
    emit(UserUpdateLoading());

    final user = usersList.firstWhere((u) => u.uid == uid);

    final updatedUser = user.copyWith(
      balance: (user.balance) + amount,
    );

    final result = await updateUserBalanceUseCase.call(updatedUser);

    result.fold(
          (error) => emit(UserError(error.message)),
          (userData) {
        userModel = userData;
        emit(UserUpdatedSuccess(userData));
      },
    );
  }



  Future<void> updateUserData(UserModel user) async {
    emit(UserUpdateLoading());
    final result = await updateUserUseCase.call(user);

    result.fold(
          (error) => emit(UserUpdateError(error.message)),
          (userData)async {
            userModel = userData;
            fetchAllUSersStreamUseCase();
        emit(AllUsersLoaded(usersList));
      },
    );
  }

  Future<void> deleteUser(String uid) async {
    emit(UserUpdateLoading());
    final result = await deleteUserUseCase.call(uid);

    result.fold(
          (error) => emit(UserUpdateError(error.message)),
          (_)async {
            fetchAllUsersStream();
        emit(AllUsersLoaded(usersList));
      },
    );
  }


  Future<void> clearUserData() async {
    userModel = null;
    emit(UserInitial());
  }

  void searchUser(String query) {
    if (query.isNotEmpty) {
      final filteredUsers = usersList.where((user) => user.displayName.toLowerCase().contains(query.toLowerCase())).toList();
      emit(AllUsersLoaded(filteredUsers));
    } else {
      emit(AllUsersLoaded(usersList));
    }
  }

}

