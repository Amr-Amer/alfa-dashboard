import 'package:alfa_dashboard/core/networking/firebase_error_factory.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/withdraw_requests/data/data_sources/withdraw_remote_data_source.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/repository/withdraw_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class WithdrawRepoImpl implements WithdrawRepository {
  final WithdrawRequestsRemoteDataSource remoteDataSource;

  WithdrawRepoImpl(this.remoteDataSource);

  @override
  Future<Either<ErrorModel, List<TransactionModel>>> fetchAllWithdraws() {
    return remoteDataSource.fetchAllWithdraws();
  }

  @override
  Future<Either<ErrorModel, TransactionModel>> updateWithdrawRequestStatus(TransactionModel transaction)async {
    try {
      await remoteDataSource.updateWithdrawRequestStatus(transaction);
      return right(transaction);
    } catch (e) {
      print( "Error: $e");
      return left(ErrorFactory.fromFirebaseError(e as FirebaseException));
    }
  }
}





