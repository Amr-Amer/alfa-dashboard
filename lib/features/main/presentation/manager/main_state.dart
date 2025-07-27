part of 'main_cubit.dart';

@immutable
sealed class MainState {}

final class MainInitialState extends MainState {}

final class MainSuccessState extends MainState {
  final List<UserModel> userModel;
  final List<TransactionModel> transactions;
  MainSuccessState({required this.userModel,required this.transactions});
}

final class MainLoadingState extends MainState {}

final class MainErrorState extends MainState {
  final String message;
  MainErrorState({required this.message});
}
