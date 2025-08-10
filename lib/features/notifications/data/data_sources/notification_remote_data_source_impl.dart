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
  Future<Either<ErrorModel, List<NotificationModel>>> fetchUserNotifications(String uid) async {
    try {
      // Assuming notifications are stored in a subcollection under the user's document
      // users/{uid}/notifications/{notificationId}
      final querySnapshot = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .collection(FirebaseConstants.notificationsCollection)
          .orderBy(FirebaseConstants.createdAt, descending: true)
          .get();

      final notifications = querySnapshot.docs.map((doc) => NotificationModel.fromMap(doc.data())).toList();
      return right(notifications);
    } on FirebaseException catch (e) {
      return left(ErrorFactory.fromFirebaseError(e));
    } catch (e) {
      return left(ErrorFactory.fromMessage(e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> markNotificationAsRead(String uid, String notificationId) async {
    try {
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .collection(FirebaseConstants.notificationsCollection)
          .doc(notificationId)
          .update({FirebaseConstants.notificationRead: true});
      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorFactory.fromFirebaseError(e));
    } catch (e) {
      return left(ErrorFactory.fromMessage(e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> addNotification(NotificationModel notification) async {
    try {
      // This method is primarily for the Cloud Function to use,
      // but included here for completeness of the data source.
      await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(notification.uid)
          .collection(FirebaseConstants.notificationsCollection)
          .doc(notification.id)
          .set(notification.toMap());
      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorFactory.fromFirebaseError(e));
    } catch (e) {
      return left(ErrorFactory.fromMessage(e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> sendNotification(NotificationModel notification) async {
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

      batch.set(mainRef, notification.toMap(), SetOptions(merge: true));
      batch.set(userRef, notification.toMap(), SetOptions(merge: true));

      await batch.commit();

      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorFactory.fromFirebaseError(e));
    } catch (e) {
      return left(ErrorFactory.fromMessage(e.toString()));
    }
  }


  @override
  Future<Either<ErrorModel, void>> markAllAsRead(String uid) async {
    try {
      // Get all unread notifications for the user
      final querySnapshot = await firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .collection(FirebaseConstants.notificationsCollection)
          .where(FirebaseConstants.notificationRead, isEqualTo: false)
          .get();

      // Update all unread notifications to read
      final batch = firestore.batch();
      final notificationsRef = firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .collection(FirebaseConstants.notificationsCollection);

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {FirebaseConstants.notificationRead: true});
      }

      await batch.commit();
      return right(null);
    } on FirebaseException catch (e) {
      return left(ErrorFactory.fromFirebaseError(e));
    } catch (e) {
      return left(ErrorFactory.fromMessage(e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<NotificationModel>>> fetchAllNotifications()async {
    try {
      // Assuming notifications are stored in a subcollection under the user's document
      // users/{uid}/notifications/{notificationId}
      final querySnapshot = await firestore
          .collection(FirebaseConstants.notificationsCollection)
          .orderBy(FirebaseConstants.createdAt, descending: true)
          .get();

      final notifications = querySnapshot.docs.map((doc) => NotificationModel.fromMap(doc.data())).toList();
      return right(notifications);
    } on FirebaseException catch (e) {
      return left(ErrorFactory.fromFirebaseError(e));
    } catch (e) {
      return left(ErrorFactory.fromMessage(e.toString()));
    }
  }

  }
