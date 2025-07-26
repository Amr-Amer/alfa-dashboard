import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/transaction/data/data_sources/transactions_remote_data_source.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class TransactionRepoImpl implements TransactionRepository {
  final TransactionsRemoteDataSource remoteDataSource;

  TransactionRepoImpl(this.remoteDataSource);


  @override
  Future<void> createTransaction({required TransactionModel transaction}) {
    return remoteDataSource.createTransaction(transaction);
  }

  @override
  Future<Either<ErrorModel, List<TransactionModel>>> fetchUserTransactions(String uid) {
    return remoteDataSource.fetchUserTransactions(uid);
  }

  @override
  Future<Either<ErrorModel, List<TransactionModel>>> fetchAllTransactions() {
    return remoteDataSource.fetchAllTransactions();
  }

  @override
  Future<Either<ErrorModel, Unit>> deleteTransaction(String transactionId) async {
    try {
      return await remoteDataSource.deleteTransaction(transactionId);
    } catch (e) {
      return left(ErrorModel(message: 'Failed to delete transaction', code: ''));
    }
  }
}





