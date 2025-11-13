import 'package:alfa_dashboard/core/networking/firebase_error_handler.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/domain/repository/deposits_repository.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:dartz/dartz.dart';

class FetchDepositsStreamUseCase
    implements StreamUseCaseNoParamWithFirebase<List<TransactionModel>> {
  final DepositsRepository repository;

  FetchDepositsStreamUseCase(this.repository);

  @override
  Stream<Either<FirebaseFailure, List<TransactionModel>>> call() {
    return repository.fetchAllDepositsStream().map(
          (transactions) => Right<FirebaseFailure, List<TransactionModel>>(transactions),
    );
  }
}