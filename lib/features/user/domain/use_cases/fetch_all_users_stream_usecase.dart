import 'package:alfa_dashboard/core/networking/firebase_error_handler.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';


class FetchAllUSersStreamUseCase
    implements StreamUseCaseNoParamWithFirebase<List<UserModel>> {
  final UserRepository repository;

  FetchAllUSersStreamUseCase(this.repository);

  @override
  Stream<Either<FirebaseFailure, List<UserModel>>> call() {
    return repository.fetchAllUsersStream().map(
          (users) => Right<FirebaseFailure, List<UserModel>>(users),
    );
  }
}
