import 'dart:async';
import 'package:alfa_dashboard/core/error/failures.dart';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/features/requests/top_up/data/models/topup_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class TopUpRemoteDataSource {
  Future<Either<Failure, TopUpModel>> createTopUp(TopUpModel topUp);
  Future<Either<Failure, TopUpModel>> updateTopUpStatus(
      String topUpId, String status);
  Stream <List<TopUpModel>> getTopUps();
  Future<Either<Failure, List<TopUpModel>>> getAllTopUps();
}


class TopUpRemoteDataSourceImpl implements TopUpRemoteDataSource {
  final FirebaseFirestore _firestore;

  TopUpRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<Either<Failure, TopUpModel>> createTopUp(TopUpModel topup) async {
    try {
      await _firestore
          .collection(FirebaseConstants.topupsCollection)
          .doc(topup.topUpId)
          .set(topup.toMap());

      return Right(topup);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TopUpModel>> updateTopUpStatus(
      String topupId, String status) async {
    try {
      await _firestore
          .collection(FirebaseConstants.topupsCollection)
          .doc(topupId)
          .update({
        'status': status,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Fetch the updated document
      final doc = await _firestore
          .collection(FirebaseConstants.topupsCollection)
          .doc(topupId)
          .get();

      if (doc.exists) {
        final topup = TopUpModel.fromMap(doc.data()!);
        return Right(topup);
      } else {
        return Left(NetworkFailure('Topup not found'));
      }
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Stream<List<TopUpModel>> getTopUps() {
    return _firestore
        .collection(FirebaseConstants.topupsCollection)
        .orderBy(FirebaseConstants.createdAt, descending: true)
        .snapshots()
        .transform(
      StreamTransformer.fromHandlers(
        handleData: (snapshot, sink) {
          final topup = snapshot.docs
              .map((doc) => TopUpModel.fromMap(doc.data()))
              .toList();
          Future.microtask(() => sink.add(topup));
        },
      ),
    );
  }

  @override
  Future<Either<Failure, List<TopUpModel>>> getAllTopUps()async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseConstants.topupsCollection)
          .orderBy(FirebaseConstants.createdAt, descending: true)
          .get();

      final topups = querySnapshot.docs
          .map((doc) => TopUpModel.fromMap(doc.data()))
          .toList();
      return Right(topups);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}

