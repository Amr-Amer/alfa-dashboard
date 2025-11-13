import 'package:alfa_dashboard/core/networking/firebase_error_handler.dart';
import 'package:alfa_dashboard/core/usecase/use_case.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/domain/repository/withdraws_repository.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:dartz/dartz.dart';

class FetchWithdrawsStreamUseCase
    implements StreamUseCaseNoParamWithFirebase<List<TransactionModel>> {
  final WithdrawsRepository repository;

  FetchWithdrawsStreamUseCase(this.repository);

  @override
  Stream<Either<FirebaseFailure, List<TransactionModel>>> call() {
    return repository.fetchAllWithdrawsStream().map(
          (transactions) => Right<FirebaseFailure, List<TransactionModel>>(transactions),
    );
  }
}