import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_factory.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class WithdrawRequestsRemoteDataSource {

  Future<Either<ErrorModel, List<TransactionModel>>> fetchAllWithdraws();

  Future<void> updateWithdrawRequestStatus(TransactionModel transaction);
}


class WithdrawRequestsRemoteDataSourceImpl implements WithdrawRequestsRemoteDataSource {

  final FirebaseFirestore firestore;

  WithdrawRequestsRemoteDataSourceImpl(this.firestore);


  @override
  Future<Either<ErrorModel, List<TransactionModel>>> fetchAllWithdraws() {
    try {
      final querySnapshot = firestore
          .collection(FirebaseConstants.transCollection)
          .where(FirebaseConstants.type, isEqualTo: FirebaseConstants.withdraw)
          .where(FirebaseConstants.status, isEqualTo: FirebaseConstants.pending)
          .orderBy(FirebaseConstants.createdAt, descending: true)
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
  Future<void> updateWithdrawRequestStatus(TransactionModel transaction) async {
    final Map<String, dynamic> updateData = {};

    updateData[FirebaseConstants.status] = transaction.status.name;

    if (transaction.adminNote.isNotEmpty) {
      updateData[FirebaseConstants.adminNote] = transaction.adminNote;
    }

    updateData[FirebaseConstants.updatedAt] = Timestamp.fromDate(transaction.updatedAt);

    if (updateData.isNotEmpty) {
      await firestore
          .collection(FirebaseConstants.transCollection)
          .doc(transaction.id)
          .update(updateData);
    }
  }

}