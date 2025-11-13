import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_factory.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSourceImpl(this.firestore);

  @override
  Future<Either<ErrorModel, void>> addNotification(
      NotificationModel notification) async {
    try {
      // This method is primarily for the Cloud Function to use,
      // but included here for completeness of the data source.
      final notificationData = notification.toMap();
      notificationData[FirebaseConstants.id] = notification.id; // Ensure ID is set in the data
      
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(notification.uid)
          .collection(FirebaseConstants.notificationsCollection)
          .doc(notification.id)
          .set(notificationData);
      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorFactory.fromFirebaseError(e));
    } catch (e) {
      return left(ErrorFactory.fromMessage(e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> sendNotification(
      NotificationModel notification) async {
    try {
      final batch = firestore.batch();
      final mainRef = firestore
          .collection(FirebaseConstants.notificationsCollection)
          .doc(notification.id);
      final userRef = firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(notification.uid)
          .collection(FirebaseConstants.notificationsCollection)
          .doc(notification.id);

      // Ensure ID is set in the data for both documents
      final notificationData = notification.toMap()..[FirebaseConstants.id] = notification.id;
      
      batch.set(mainRef, notificationData, SetOptions(merge: true));
      batch.set(userRef, notificationData, SetOptions(merge: true));

      await batch.commit();

      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorFactory.fromFirebaseError(e));
    } catch (e) {
      return left(ErrorFactory.fromMessage(e.toString()));
    }
  }
}
