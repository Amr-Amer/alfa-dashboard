import 'package:alfa_dashboard/core/networking/firebase_error_handler.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/requests/top_up/data/models/topup_model.dart';
import 'package:alfa_dashboard/features/requests/top_up/domain/repository/topup_repository.dart';
import 'package:dartz/dartz.dart';

class GetTopUpStreamUseCase
    implements StreamUseCaseNoParamWithFirebase<List<TopUpModel>> {
  final TopUpRepository repository;

  GetTopUpStreamUseCase(this.repository);

  @override
  Stream<Either<FirebaseFailure, List<TopUpModel>>> call() {
    return repository.getUserTopUps().map(
            (topUp) => Right<FirebaseFailure, List<TopUpModel>>(topUp));
  }
}