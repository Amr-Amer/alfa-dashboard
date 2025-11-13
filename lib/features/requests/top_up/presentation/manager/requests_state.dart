import 'package:alfa_dashboard/features/requests/top_up/data/models/topup_model.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:flutter/foundation.dart';

abstract class RequestsState {}

class RequestsInitial extends RequestsState {}

class RequestsLoading extends RequestsState {}

class RequestsUpdating extends RequestsState {}

class RequestsLoaded extends RequestsState {

  final List<TransactionModel> transactions;

  RequestsLoaded(this.transactions);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequestsLoaded && listEquals(other.transactions, transactions);
  }
  @override
  int get hashCode => transactions.hashCode;
}

class RequestsError extends RequestsState {
  final String message;

  RequestsError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequestsError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}


class TopUpsLoaded extends RequestsState {

  final List<TopUpModel> topUps;

  TopUpsLoaded(this.topUps);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequestsLoaded && listEquals(other.transactions, topUps);
  }
  @override
  int get hashCode => topUps.hashCode;
}

class TopUpsError extends RequestsState {
  final String message;

  TopUpsError(this.message);}

class TopUpsLoading extends RequestsState {}