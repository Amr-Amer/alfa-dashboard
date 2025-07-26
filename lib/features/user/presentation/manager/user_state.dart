import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  UserLoaded(this.user);
}

class AllUsersLoaded extends UserState with EquatableMixin {
  final List<UserModel> users;

  AllUsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserUpdatedSuccess extends UserState {
  final UserModel user;

  UserUpdatedSuccess(this.user);
}

class UpdateUserBalance extends UserState {
  final UserModel user;

  UpdateUserBalance(this.user);
}

class UserUpdateLoading extends UserState {}

class UserUpdateError extends UserState {
  final String message;

  UserUpdateError(this.message);
}


class UserError extends UserState {
  final String message;

  UserError(this.message);
}

