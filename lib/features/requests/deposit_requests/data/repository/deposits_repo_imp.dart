import 'package:alfa_dashboard/core/networking/firebase_error_factory.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/data/data_sources/deposit_remote_data_source.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/domain/repository/deposits_repository.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DepositsRepoImpl implements DepositsRepository {

  final DepositsRemoteDataSource _remoteDataSource;

  DepositsRepoImpl(this._remoteDataSource);
  @override
  Stream<List<TransactionModel>> fetchAllDepositsStream() {
    return _remoteDataSource.fetchAllDepositsStream();
  }

  @override
  Future<Either<ErrorModel, TransactionModel>> updateRequestStatus(TransactionModel transaction) async{
    try {
      await _remoteDataSource.updateRequestStatus(transaction);
      return right(transaction);
    } catch (e) {
      if (kDebugMode) {
        print( "Error: $e");
      }
      return left(ErrorFactory.fromFirebaseError(e as FirebaseException));
    }
  }
}