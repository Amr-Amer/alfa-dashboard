import 'package:alfa_dashboard/core/networking/firebase_error_handler.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/withdraw_requests/domain/repository/withdraw_repository.dart';
import 'package:dartz/dartz.dart';

class GetWithdrawRequestsStreamUseCase
    implements StreamUseCaseNoParamWithFirebase<List<TransactionModel>> {
  final WithdrawRepository repository;

  GetWithdrawRequestsStreamUseCase(this.repository);

  @override
  Stream<Either<FirebaseFailure, List<TransactionModel>>> call() {
    return repository.getWithdrawRequestsStream().map(
          (transactions) => Right<FirebaseFailure, List<TransactionModel>>(transactions),
    );
  }
}