import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:dartz/dartz.dart';

abstract class WithdrawsRepository {

  Stream<List<TransactionModel>> fetchAllWithdrawsStream();
  Future<Either<ErrorModel, TransactionModel>> updateRequestStatus(TransactionModel transaction);
}