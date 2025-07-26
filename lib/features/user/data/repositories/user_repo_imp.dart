import 'package:alfa_dashboard/core/networking/firebase_error_factory.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImp implements UserRepository {
  final AuthFireStoreDataSource authFireStoreDataSource;

  UserRepositoryImp(this.authFireStoreDataSource);

  @override
  Future<Either<ErrorModel, UserModel>> fetchUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        return left(ErrorFactory.unKnownError());
      }

      return await authFireStoreDataSource.fetchUserData(userId);
    } catch (_) {
      return left(ErrorFactory.unKnownError());
    }
  }

  @override
  Future<Either<ErrorModel, UserModel>> updateUser(UserModel user) async {
    try {
      await authFireStoreDataSource.updateUser(user);
      return right(user);
    } catch (e) {
      print("updateUserError $e");
      return left(ErrorFactory.unKnownError());
    }
  }

  @override
  Future<Either<ErrorModel, List<UserModel>>> fetchAllUsers()async {
    try {
      return await authFireStoreDataSource.fetchAllUsers();
    } catch (e) {
      print("fetchAllUsersError $e");
      return left(ErrorFactory.unKnownError());
    }
  }

  @override
  Future<Either<ErrorModel, UserModel>> updateUserBalance(UserModel user)async {
    try{
      await authFireStoreDataSource.updateUserBalance( user);
      return right(user);
    }catch(e){
      print("updateUserBalanceError $e");
      return left(ErrorFactory.unKnownError());
    }
  }

  @override
  Future<Either<ErrorModel, Unit>> deleteUser(String uid) async {
   try{
     await authFireStoreDataSource.deleteUser(uid);
     return right(unit);
   }catch(e){
     print("deleteUserError $e");
     return left(ErrorFactory.unKnownError());
   }
  }
}
