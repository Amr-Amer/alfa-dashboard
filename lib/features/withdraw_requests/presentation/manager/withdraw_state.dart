import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:flutter/foundation.dart';

abstract class WithdrawRequestsState {}

class WithdrawRequestsInitial extends WithdrawRequestsState {}

class WithdrawRequestsLoading extends WithdrawRequestsState {}

class WithdrawRequestsUpdating extends WithdrawRequestsState {}

class WithdrawRequestsLoaded extends WithdrawRequestsState {
  final List<TransactionModel> transactions;

  WithdrawRequestsLoaded(this.transactions);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WithdrawRequestsLoaded && listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode => transactions.hashCode;
}

class WithdrawRequestsError extends WithdrawRequestsState {
  final String message;

  WithdrawRequestsError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WithdrawRequestsError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
