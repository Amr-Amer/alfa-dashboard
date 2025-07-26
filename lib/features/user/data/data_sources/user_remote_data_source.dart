import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_factory.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class AuthFireStoreDataSource {
  Future<void> createUser(UserModel user);
  Future<Either<ErrorModel, UserModel>> fetchUserData(String uid);
  Future<Either<ErrorModel, List<UserModel>>> fetchAllUsers();
  Future<void> updateUser(UserModel user);
  Future<void> updateUserBalance(UserModel user);
  Future<void> deleteUser(String uid);
  }

class AuthFireStoreDataSourceImpl implements AuthFireStoreDataSource {
  final FirebaseFirestore fireStore;

  AuthFireStoreDataSourceImpl(this.fireStore);

  @override
  Future<void> createUser(UserModel user) async {
    await fireStore
        .collection(FirebaseConstants.usersCollection)
        .doc(user.uid)
        .set(user.toMap());
  }

  @override
  Future<Either<ErrorModel, UserModel>> fetchUserData(String uid) async {
    try {
      final doc = await fireStore
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .get();

      if (!doc.exists || doc.data() == null) {
        return left(ErrorFactory.userNotFoundError());
      }

      final data = doc.data()!;
      return right(UserModel.fromMap(data));
    } catch (e) {
      return left(ErrorFactory.unKnownError());
    }
  }

  @override
  Future<void> updateUserBalance(UserModel user) async {
    try {
      final doc = fireStore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid);

      await doc.update({
        FirebaseConstants.balance: FieldValue.increment(user.balance)
      });
    } catch (e) {
      throw ErrorFactory.fromFirebaseError(e as FirebaseException);
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final Map<String, dynamic> updateData = {};

    if (user.displayName.isNotEmpty) {
      updateData[FirebaseConstants.displayName] = user.displayName;
    }
    if (user.phoneNumber.isNotEmpty) {
      updateData[FirebaseConstants.phoneNumber] = user.phoneNumber;
    }

    if (user.status.name.isNotEmpty) {
      updateData[FirebaseConstants.status] = user.status.name;
    }
    if (user.balance
        .toString()
        .isNotEmpty) {
      updateData[FirebaseConstants.balance] = user.balance;
    }

    if (user.address != null && user.address!
        .isNotEmpty) {
      updateData[FirebaseConstants.address] = user.address;
    }
    if (user.updatedAt != null) {
      updateData[FirebaseConstants.updatedAt] =
          Timestamp.fromDate(user.updatedAt!);
    } else {
      updateData[FirebaseConstants.updatedAt] = FieldValue.serverTimestamp();
    }
    if (user.languageCode != null && user.languageCode!.isNotEmpty) {
      updateData[FirebaseConstants.languageCode] = user.languageCode;
    }
    updateData[FirebaseConstants.notificationsEnabled] =
        user.notificationsEnabled;
    if (updateData.isNotEmpty) {
      await fireStore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .update(updateData);
    }
  }

  @override
  Future<Either<ErrorModel, List<UserModel>>> fetchAllUsers() async {
    try {
      final doc = fireStore
          .collection(FirebaseConstants.usersCollection)
          .get();

      return doc.then((snapshot) {
        final users = snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList();
        return right(users);
      });
    } catch (e) {
      return Future.error(
          ErrorFactory.fromFirebaseError(e as FirebaseException));
    }
  }

  @override
  Future<void> deleteUser(String uid) {
    return fireStore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .delete();
  }
}
