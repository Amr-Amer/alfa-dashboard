import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_factory.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';


abstract class TransactionsRemoteDataSource {

  Future<void> createTransaction(TransactionModel transaction);

  Future<Either<ErrorModel, List<TransactionModel>>> fetchUserTransactions(String uid);

  Future<Either<ErrorModel, List<TransactionModel>>> fetchAllTransactions();
}


class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {

  final FirebaseFirestore firestore;

  TransactionsRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createTransaction(TransactionModel transaction) {
    try {
      final ref = firestore.collection(FirebaseConstants.transCollection).doc(
          transaction.id);
      return ref.set(transaction.toMap());
    } catch (e) {
      return Future.error(
          ErrorFactory.fromFirebaseError(e as FirebaseException));
    }
  }

  @override
  Future<Either<ErrorModel, List<TransactionModel>>> fetchUserTransactions(String uid) {
    try {
      final querySnapshot = firestore
          .collection(FirebaseConstants.transCollection)
          .where(FirebaseConstants.uId, isEqualTo: uid)
          .orderBy(FirebaseConstants.createdAt, descending: true)
          .limitToLast(FirebaseConstants.transactionsListLimit)
          .get();

      return querySnapshot.then((snapshot) {
        final transactions = snapshot.docs.map((doc) => TransactionModel.fromMap(doc.data())).toList();
        return right(transactions);
      });
    } catch (e) {
      return Future.error(
          ErrorFactory.fromFirebaseError(e as FirebaseException));
    }
  }

  @override
  Future<Either<ErrorModel, List<TransactionModel>>> fetchAllTransactions() {
    try {
      final querySnapshot = firestore
          .collection(FirebaseConstants.transCollection)
          .orderBy(FirebaseConstants.createdAt, descending: true)
          .limitToLast(FirebaseConstants.transactionsAdminListLimit)
          .get();

      return querySnapshot.then((snapshot) {
        final transactions = snapshot.docs.map((doc) => TransactionModel.fromMap(doc.data())).toList();
        return right(transactions);
      });
    } catch (e) {
      return Future.error(
          ErrorFactory.fromFirebaseError(e as FirebaseException));
    }
  }
}