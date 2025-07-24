import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

class FetchAllUSersUseCase implements UseCases<List<UserModel>, NoParams> {

  final UserRepository userRepo;

  FetchAllUSersUseCase(this.userRepo);

  @override
  Future<Either<ErrorModel, List<UserModel>>> call(NoParams params) async {
    return await userRepo.fetchAllUsers();
  }
}