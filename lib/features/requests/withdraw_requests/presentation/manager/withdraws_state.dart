part of 'withdraws_cubit.dart';

sealed class WithdrawsState {}

final class WithdrawsInitial extends WithdrawsState {}

class WithdrawsLoading extends WithdrawsState {}

class WithdrawsUpdating extends WithdrawsState {}

class WithdrawsError extends WithdrawsState {
  final String message;
  WithdrawsError(this.message);
}

class WithdrawsLoaded extends WithdrawsState {
  final List<TransactionModel> transactions;
  WithdrawsLoaded(this.transactions);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WithdrawsLoaded && listEquals(other.transactions, transactions);
  }
  @override
  int get hashCode => transactions.hashCode;
}



