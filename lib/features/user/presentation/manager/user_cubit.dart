import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_all_users_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/fetch_user_data_usecse.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/update_user_balance_usecase.dart';
import 'package:alfa_dashboard/features/user/domain/use_cases/update_user_data_usecase.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';

class UserCubit extends Cubit<UserState> {
  final FetchUserDataUseCase fetchUserDataUseCase;
  final UpdateUserDataUseCase updateUserUseCase;
  final FetchAllUSersUseCase fetchAllUSersUseCase;
  final UpdateUserBalanceUseCase updateUserBalanceUseCase;

  UserCubit({
    required this.fetchUserDataUseCase,
    required this.updateUserUseCase,
    required this.fetchAllUSersUseCase,
    required this.updateUserBalanceUseCase
  }) : super(UserInitial()) {
    fetchUserData();
  }


  Future<void> fetchUserData() async {
    emit(UserLoading());
    final result = await fetchUserDataUseCase.call(NoParams());

    result.fold(
          (error) => emit(UserError(error.message)),
          (userData) {
        userModel = userData;
        emit(UserLoaded(userData));
      },
    );
    if (kDebugMode) {
      print("user data.................... ");
      print(user);
    }
  }

    Future<void> fetchAllUsers() async {
      emit(UserLoading());
      final result = await fetchAllUSersUseCase.call(NoParams());

      result.fold(
            (error) => emit(UserError(error.message)),
            (userData) {
              usersList = userData;
          emit(AllUsersLoaded(userData));
        },
      );
      if (kDebugMode) {
        print("all users data.................... ");
        print(user);
      }
    }

  Future<void> updateUserBalance(double amount, String uid) async {
    emit(UserUpdateLoading());
    final result = await updateUserBalanceUseCase.call(
        UserModel(
            uid: uid,
            balance: amount,
            email: '',
            displayName: '',
            emailVerified: false,
            phoneNumber: ''
        )
    );

    result.fold(
          (error) => emit(UserError(error.message)),
          (userData) {
        userModel = userData;
        emit(UserUpdated(userData));
      },
    );
  }


  Future<void> increaseBalance(double amount) async {
    if (userModel != null) {
      final updatedUser = userModel!.copyWith(
        balance: userModel!.balance + amount,
        totalEarnings: (userModel!.totalEarnings ?? 0) + amount,
      );
      await updateUserData(updatedUser);
    }
  }


  Future<void> updateUserData(UserModel user) async {
    emit(UserUpdateLoading());
    final result = await updateUserUseCase.call(user);

    result.fold(
          (error) => emit(UserError(error.message)),
          (userData) {
            userModel = userData;
        emit(UserUpdated(userData));
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

