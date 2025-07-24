part of 'transaction_cubit.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionsLoaded extends TransactionState {
  final List<TransactionModel> transactions;

  TransactionsLoaded(this.transactions);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionsLoaded && listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode => transactions.hashCode;
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}