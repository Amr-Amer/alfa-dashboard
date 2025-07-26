import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_method.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final double commission;
  final String currency;
  final TransactionMethod method;
  final String note;
  final TransactionStatus status;
  final TransactionType type;
  final String uid;
  final String userName;
  final String bankTransactionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String adminNote;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.commission,
    required this.currency,
    required this.method,
    required this.note,
    required this.status,
    required this.type,
    required this.uid,
    required this.userName,
    required this.bankTransactionId,
    required this.createdAt,
    required this.updatedAt,
    required this.adminNote,
  });

  @override
  List<Object?> get props => [
    id,
    amount,
    commission,
    currency,
    method,
    note,
    status,
    type,
    uid,
    userName,
    bankTransactionId,
    createdAt,
    updatedAt,
    adminNote
  ];
}
