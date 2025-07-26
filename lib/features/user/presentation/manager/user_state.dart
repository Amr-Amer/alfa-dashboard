import 'package:alfa_dashboard/features/user/data/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;

  UserLoaded(this.user);
}

class AllUsersLoaded extends UserState {
  final List<UserModel> users;

  AllUsersLoaded(this.users);
}

class UserUpdated extends UserState {
  final UserModel user;

  UserUpdated(this.user);
}
class UpdateUserBalance extends UserState {
  final UserModel user;

  UpdateUserBalance(this.user);
}

class UserUpdateLoading extends UserState {}


class UserError extends UserState {
  final String message;

  UserError(this.message);
}
