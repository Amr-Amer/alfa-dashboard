import 'dart:async';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class WithdrawsRemoteDataSource {

  Stream<List<TransactionModel>> fetchAllWithdrawsStream();

  Future<void> updateRequestStatus(TransactionModel transaction);
}

class WithdrawsRemoteDataSourceImpl implements WithdrawsRemoteDataSource {
  final FirebaseFirestore _firestore;

  WithdrawsRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<TransactionModel>> fetchAllWithdrawsStream() {
    return _firestore
        .collection(FirebaseConstants.transCollection)
        .where(
      FirebaseConstants.transType,
      isEqualTo: TransactionType.withdraw.name,
    )
        .where(FirebaseConstants.status, isEqualTo: FirebaseConstants.pending)
        .orderBy(FirebaseConstants.createdAt, descending: true)
        .snapshots()
        .transform(
      StreamTransformer.fromHandlers(
        handleData: (snapshot, sink) {
          final transactions = snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList();
          Future.microtask(() => sink.add(transactions));
        },
      ),
    );
  }

  @override
  Future<void> updateRequestStatus(TransactionModel transaction) async {
    final Map<String, dynamic> updateData = {};

    updateData[FirebaseConstants.status] = transaction.status.name;

    if (transaction.adminNote.isNotEmpty) {
      updateData[FirebaseConstants.adminNote] = transaction.adminNote;
    }

    updateData[FirebaseConstants.updatedAt] = Timestamp.fromDate(transaction.updatedAt);

    if (updateData.isNotEmpty) {
      await _firestore
          .collection(FirebaseConstants.transCollection)
          .doc(transaction.id)
          .update(updateData);
    }
  }
}


