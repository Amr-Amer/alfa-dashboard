import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/user/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

class DeleteUserUseCase implements UseCases<Unit, String> {

  final UserRepository userRepo;

  DeleteUserUseCase(this.userRepo);

  @override
  Future<Either<ErrorModel, Unit>> call(String uid) {
    return userRepo.deleteUser(uid);
  }
}