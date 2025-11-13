import 'dart:async';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DepositsRemoteDataSource {

  Stream<List<TransactionModel>> fetchAllDepositsStream();

  Future<void> updateRequestStatus(TransactionModel transaction);
}

class DepositsRemoteDataSourceImpl implements DepositsRemoteDataSource {
  final FirebaseFirestore _firestore;

  DepositsRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<TransactionModel>> fetchAllDepositsStream() {
    return _firestore
        .collection(FirebaseConstants.transCollection)
        .where(
      FirebaseConstants.transType,
      isEqualTo: TransactionType.deposit.name,
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


