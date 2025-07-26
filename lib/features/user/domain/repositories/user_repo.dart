import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {

  Future<Either<ErrorModel,UserModel>> fetchUserData();

  Future<Either<ErrorModel,List<UserModel>>> fetchAllUsers();

  Future<Either<ErrorModel,UserModel>> updateUser(UserModel user);

  Future<Either<ErrorModel,UserModel>> updateUserBalance(UserModel user);
}