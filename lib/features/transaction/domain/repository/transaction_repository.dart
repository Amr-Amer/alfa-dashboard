import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:dartz/dartz.dart';

abstract class TransactionRepository {

  Future<void> createTransaction({required TransactionModel transaction});

  Future<Either<ErrorModel, List<TransactionModel>>> fetchUserTransactions(String uid);

  Future<Either<ErrorModel, List<TransactionModel>>> fetchAllTransactions();

}
