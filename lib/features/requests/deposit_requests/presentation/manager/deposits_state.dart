part of 'deposits_cubit.dart';

sealed class DepositsState {}

final class DepositsInitial extends DepositsState {}

class DepositsLoading extends DepositsState {}

class DepositsUpdating extends DepositsState {}

class DepositsError extends DepositsState {
  final String message;
  DepositsError(this.message);
}

class DepositsLoaded extends DepositsState {
  final List<TransactionModel> transactions;
  DepositsLoaded(this.transactions);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DepositsLoaded && listEquals(other.transactions, transactions);
  }
  @override
  int get hashCode => transactions.hashCode;
}



