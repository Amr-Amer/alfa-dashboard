import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

class UpdateUserBalanceUseCase implements UseCases<UserModel, UserModel> {

  final UserRepository userRepo;

  UpdateUserBalanceUseCase(this.userRepo);

  @override
  Future<Either<ErrorModel, UserModel>> call(UserModel user) async {
    return await userRepo.updateUserBalance(user);
  }
}